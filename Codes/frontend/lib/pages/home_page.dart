import 'dart:math';
import 'dart:async';
import 'package:frontend/pages/view_comment_page.dart';

import 'storage.dart';
import 'add_dialog.dart';
import 'data_widget.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/add_post_page.dart';
import 'package:frontend/pages/view_post_page.dart';
import 'package:frontend/pages/search_page_new.dart';
import 'package:frontend/services/shared_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color getRandomColor() {
    var r = Random();
    return Color.fromRGBO(r.nextInt(256), r.nextInt(256), r.nextInt(256), 1);
  }

  @override
  Widget build(BuildContext context) {
    SharedService.checkSession(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      initialRoute: "/home",
      routes: {
        "/home": (c) => const DashboardWidget(),
        "/addpost": (c) => const addPostPage(),
        "/editposts": (c) => const viewPostPage(),
        "/search": (c) => SearchPage(),
        "/login": (c) => const LoginPage(),
        "/editcomments": (c) => const viewCommentPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final ScrollController scrollController = ScrollController();

  late var itemController =
      DashboardItemController<ColoredDashboardItem>.withDelegate(
          itemStorageDelegate: storage);

  bool refreshing = false;

  var storage = MyItemStorage();

  int? slot;

  setSlot() {
    var w = MediaQuery.of(context).size.width;
    setState(() {
      slot = w > 600
          ? w > 900
              ? 8
              : 6
          : 4;
    });
  }

  List<String> d = [];

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    slot = w > 600
        ? w > 900
            ? 8
            : 6
        : 4;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4285F4),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await storage.clear();
                setState(() {
                  refreshing = true;
                });
                storage = MyItemStorage();
                itemController =
                    DashboardItemController<ColoredDashboardItem>.withDelegate(
                        itemStorageDelegate: storage);
                Future.delayed(const Duration(milliseconds: 150)).then((value) {
                  setState(() {
                    refreshing = false;
                  });
                });
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                itemController.isEditing = !itemController.isEditing;
                setState(() {});
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed('/login');
                SharedService.logout(context);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
        child: refreshing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Dashboard<ColoredDashboardItem>(
                shrinkToPlace: false,
                slideToTop: true,
                absorbPointer: false,
                padding: const EdgeInsets.all(8),
                horizontalSpace: 8,
                verticalSpace: 8,
                slotAspectRatio: 1,
                animateEverytime: true,
                dashboardItemController: itemController,
                slotCount: slot!,
                errorPlaceholder: (e, s) {
                  return Text("$e , $s");
                },
                itemStyle: ItemStyle(
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                physics: const RangeMaintainingScrollPhysics(),
                editModeSettings: EditModeSettings(
                    paintBackgroundLines: true,
                    resizeCursorSide: 15,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                    backgroundStyle: const EditModeBackgroundStyle(
                        lineColor: Colors.black38,
                        lineWidth: 0.5,
                        dualLineHorizontal: true,
                        dualLineVertical: true)),
                itemBuilder: (ColoredDashboardItem item) {
                  var layout = item.layoutData;

                  if (item.data != null) {
                    return DataWidget(
                      item: item,
                    );
                  }

                  return Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Text(
                              "ID: ${item.identifier}\n${[
                                "x: ${layout.startX}",
                                "y: ${layout.startY}",
                                "w: ${layout.width}",
                                "h: ${layout.height}",
                                if (layout.minWidth != 1)
                                  "minW: ${layout.minWidth}",
                                if (layout.minHeight != 1)
                                  "minH: ${layout.minHeight}",
                                if (layout.maxWidth != null)
                                  "maxW: ${layout.maxWidth}",
                                if (layout.maxHeight != null)
                                  "maxH : ${layout.maxHeight}"
                              ].join("\n")}",
                              style: const TextStyle(color: Colors.white),
                            )),
                      ),
                      if (itemController.isEditing)
                        Positioned(
                            right: 5,
                            top: 5,
                            child: InkResponse(
                                radius: 20,
                                onTap: () {
                                  itemController.delete(item.identifier);
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 20,
                                )))
                    ],
                  );
                },
              ),
      ),
    );
  }

  Future<void> add(BuildContext context) async {
    var res = await showDialog(
        context: context,
        builder: (c) {
          return const AddDialog();
        });

    if (res != null) {
      itemController.add(
          ColoredDashboardItem(
              color: res[6],
              width: res[0],
              height: res[1],
              startX: 1,
              startY: 3,
              identifier: (Random().nextInt(100000) + 4).toString(),
              minWidth: res[2],
              minHeight: res[3],
              maxWidth: res[4] == 0 ? null : res[4],
              maxHeight: res[5] == 0 ? null : res[5]),
          mountToTop: false);
    }
  }
}

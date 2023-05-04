import 'package:flutter/material.dart';
import 'package:frontend/helper/common.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/views/widgets/inherited_widgets/inherited_user_model.dart';

class UserDetails extends StatelessWidget {
  final PostModel postData;

  const UserDetails({required this.postData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: APIService.getUser(postData.ownerUserId),
      builder: (context, snapshot) {
        Widget ret;
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          String uname = snapshot.data?.displayName ?? "-No username-";
          ret = Text(uname);
        } else {
          ret = const Text('User Name appears here...');
        }
        return ret;
      },
    );
  }
}

class _UserNameAndEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserModel userData = InheritedUserModel.of(context)!.userData;
    final TextStyle? nameTheme = Theme.of(context).textTheme.titleMedium;
    final int flex = isLandscape(context) ? 10 : 5;
    print(userData.displayName);
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(userData.displayName, style: nameTheme),
            const SizedBox(height: 2.0),
          ],
        ),
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final UserModel userData = InheritedUserModel.of(context)!.userData;
    return const Expanded(
      flex: 1,
      child: CircleAvatar(
        backgroundImage: AssetImage("assets/images/logo.png"),
      ),
    );
  }
}

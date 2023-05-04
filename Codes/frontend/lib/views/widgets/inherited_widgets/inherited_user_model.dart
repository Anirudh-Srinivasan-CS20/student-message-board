import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';

class InheritedUserModel extends InheritedWidget {
  final UserModel userData;
  final Widget child;

  InheritedUserModel({required this.userData, required this.child})
      : super(child: child);

  static InheritedUserModel? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedUserModel>();
  }

  @override
  bool updateShouldNotify(InheritedUserModel oldWidget) {
    return true;
  }
}

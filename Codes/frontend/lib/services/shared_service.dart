import 'package:flutter/material.dart';
import 'package:frontend/models/login_response_model.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class SharedService {
  static Future<void> setLoginDetails(
    LoginResponseModel model,
  ) async {
    await SessionManager().set("id", model.data);
    await SessionManager().set("isLoggedIn", true);
  }

  static Future<void> checkSession(
    BuildContext context,
  ) async {
    bool loginStatus = await SessionManager().get("isLoggedIn") ?? false;
    int id = await SessionManager().get("id");
    print("Awaiting status...");
    if (!loginStatus) {
      print("Calling logout");
      logout(context);
    }
    print(id);
  }

  static Future<void> logout(
    BuildContext context,
  ) async {
    print("Logging out...");
    await SessionManager().destroy();
    Navigator.of(context).restorablePushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }
}

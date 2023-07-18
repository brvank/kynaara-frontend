import 'package:flutter/material.dart';
import 'package:kynaara_frontend/presentation/screens/login_screen.dart';
import 'package:kynaara_frontend/presentation/widgets/session_expired_dialog.dart';

String superAdmin = "Super Admin", admin = "Admin", salesPerson = "Sales Person";

void logoutUser(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return SessionExpiredDialog(callback: () {
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
                  return const LoginScreen();
                }), ModalRoute.withName("/login"));
          }
        });
      });
}

int userLevel(String userType){
  Map<String, int> userMap = Map();
  userMap[superAdmin] = 1;
  userMap[admin] = 2;
  userMap[salesPerson] = 3;

  int? result = userMap[userType];
  result ??= 0;
  return result;
}
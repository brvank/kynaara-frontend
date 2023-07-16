import 'package:flutter/material.dart';
import 'package:kynaara_frontend/presentation/screens/login_screen.dart';
import 'package:kynaara_frontend/presentation/widgets/session_expired_dialog.dart';

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
import 'package:flutter/material.dart';
import 'package:kynaara_frontend/presentation/screens/login_screen.dart';
import 'package:kynaara_frontend/presentation/widgets/custom_button.dart';
import 'package:kynaara_frontend/presentation/widgets/session_expired_dialog.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';

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

String createProductRedirectLink(String productLink){
  return "${APIs().baseUrl}${APIs().redirect}?q=$productLink";
}

enum TabDirection{
  LEFT,
  MID,
  RIGHT
}

class TableTabs{
  static Widget headerTab(String text, TabDirection tabDirection){
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.only(
          topLeft: tabDirection == TabDirection.LEFT ? const Radius.circular(8) : Radius.zero,
          topRight: tabDirection == TabDirection.RIGHT ? const Radius.circular(8) : Radius.zero,
        ),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
    );
  }

  static Widget tableTab(String text){
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(0.5),
      decoration: const BoxDecoration(
          color: Colors.white,
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
    );
  }

  static Widget buttonTableTab(String text, Function callback){
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(0.5),
      alignment: Alignment.centerRight,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: (){callback();},
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        ),
      ),
    );
  }
}
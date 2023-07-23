import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/widgets/custom_button.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';

class UserSelectDialog extends StatefulWidget {
  final int userLevel;
  const UserSelectDialog({super.key, required this.userLevel});

  @override
  State<UserSelectDialog> createState() => _UserSelectDialogState();
}

class _UserSelectDialogState extends State<UserSelectDialog> {
  TextEditingController _userNameTextEditingController =
      TextEditingController();
  bool loading = false;
  bool error = false;

  late Timer? timer;
  List<User> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timer = null;

    _userNameTextEditingController.addListener(() {
      if (_userNameTextEditingController.text.isNotEmpty) {
        resetTimer();
      } else {
        if (timer != null) {
          if (timer!.isActive) {
            timer!.cancel();
          }
        }
      }
    });
  }

  void resetTimer() {
    error = false;
    loading = false;
    setState(() {});
    if (timer != null) {
      if (timer!.isActive) {
        timer!.cancel();
      }
    }
    timer = Timer(Duration(milliseconds: 1500), () {
      setState(() {
        getUsers();
      });
    });
  }

  void getUsers() async {
    ApiService apiService = ApiService();
    APIs apIs = APIs();

    error = false;
    loading = true;
    try {
      var response = await apiService.execute(
          "${apIs.baseUrl}${apIs.getUsers}?start=0&size=3&userName=${_userNameTextEditingController.text}&userLevel=${widget.userLevel}",
          ApiMethod.get);
      var jsonArray = jsonDecode(response.body)['data']['result'];

      users = [];

      for (int i = 0; i < jsonArray.length; i++) {
        users.add(User.fromJson(jsonArray[i]));
      }
    } catch (e) {
      error = true;
    }

    loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(8),
        width: MediaQuery.sizeOf(context).width * 0.6,
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: TextField(
                autofocus: true,
                cursorColor: Colors.deepOrange,
                controller: _userNameTextEditingController,
                decoration: const InputDecoration(
                    labelText: "Search Channel",
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.orangeAccent)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.orangeAccent))),
                enabled: !loading,
              ),
            ),
            loading
                ? const Expanded(
                    flex: 1,
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )),
                  )
                : (error
                    ? const Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "Something went wrong!",
                          style: TextStyle(
                              color: Colors.brown, fontWeight: FontWeight.bold),
                        )),
                      )
                    : Expanded(
                        flex: 1,
                        child: ListView.builder(
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(users[i].name),
                              onTap: () {
                                returnUser(users[i]);
                              },
                            );
                          },
                          itemCount: users.length,
                        ),
                      )),
            CustomButton(
                text: "Cancel",
                callback: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  void returnUser(User user) {
    Navigator.pop(context, user);
  }
}

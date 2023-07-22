import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/business_logic/controller/login_screen_controller.dart';
import 'package:kynaara_frontend/presentation/screens/home_screen.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';
import 'package:kynaara_frontend/utils/constants/ui_text_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginScreenController _loginScreenController;

  late TextEditingController _userNameController;
  late TextEditingController _passwordController;

  bool _loginButtonEnable = false;

  @override
  void initState() {
    super.initState();

    _loginScreenController = LoginScreenController();

    _userNameController = TextEditingController();
    _passwordController = TextEditingController();

    _userNameController.addListener(() {
      setButtonEnableCheck();
    });

    _passwordController.addListener(() {
      setButtonEnableCheck();
    });
  }

  void setButtonEnableCheck() {
    setState(() {
      if (_userNameController.value.text.isEmpty ||
          _passwordController.value.text.isEmpty) {
        _loginButtonEnable = false;
      } else {
        _loginButtonEnable = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 3,
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/banner.png"),
                          fit: BoxFit.fitHeight)))),
          Expanded(flex: 2, child: loginForm())
        ],
      ),
    );
  }

  Widget loginForm() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoaderBloc>(
          create: (context) {
            return _loginScreenController.loaderBloc;
          },
        ),
        BlocProvider<MessageBloc>(
          create: (context) {
            return _loginScreenController.messageBloc;
          },
        )
      ],
      child: BlocConsumer<MessageBloc, String>(
        listener: (context, state) {
          if (state.isNotEmpty) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state),
                duration: const Duration(seconds: 2),
              ));
            }
          }
        },
        builder: (BuildContext context, state) {
          return BlocBuilder<LoaderBloc, bool>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(margin: const EdgeInsets.all(8), child: Text(UITextConstants.appName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
                    Container(
                      margin: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                      child: TextField(
                        autofocus: true,
                        cursorColor: Colors.orangeAccent,
                        controller: _userNameController,
                        style: TextStyle(color: state ? Colors.grey : Colors.orangeAccent),
                        decoration: const InputDecoration(
                          labelText: "User Name",
                          border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.orangeAccent)),
                          disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.orangeAccent))
                        ),
                        enabled: state ? false : true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                      child: TextField(
                        autofocus: true,
                        cursorColor: Colors.orangeAccent,
                        obscureText: true,
                        obscuringCharacter: '*',
                        controller: _passwordController,
                        style: TextStyle(color: state ? Colors.grey : Colors.orangeAccent),
                        decoration: const InputDecoration(
                          labelText: "Password",
                            border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.orangeAccent)),
                            disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.orangeAccent))
                        ),
                        enabled: state ? false : true,
                      ),
                    ),
                    MouseRegion(
                      cursor: _loginButtonEnable && !state
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.forbidden,
                      child: GestureDetector(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          margin: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                          padding: const EdgeInsets.only(left: 4, right: 4, top: 12, bottom: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            color: (_loginButtonEnable && !state) ? Colors.orangeAccent : Colors.grey,
                            border: Border.all(width: 2, color: (_loginButtonEnable && !state) ? Colors.orangeAccent : Colors.grey)
                          ),
                          child: Text(state ? "Logging you in..." : "Login", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                        onTap: () async {
                          if (_loginButtonEnable) {
                            _loginScreenController.login(
                                _userNameController.value.text,
                                _passwordController.value.text, () {
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const HomeScreen();
                                }), ModalRoute.withName("/home"));
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

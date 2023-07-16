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
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 3,
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/banner.png"),
                            fit: BoxFit.fitHeight)))),
            Expanded(flex: 2, child: loginForm())
          ],
        ),
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
                duration: const Duration(seconds: 1),
              ));
            }
          }
        },
        builder: (BuildContext context, state) {
          return Container(
            child: BlocBuilder<LoaderBloc, bool>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(UITextConstants.appName),
                    TextField(
                      autofocus: true,
                      cursorColor: Colors.deepOrange,
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        border: InputBorder.none,
                      ),
                      enabled: state ? false : true,
                    ),
                    TextField(
                      autofocus: true,
                      cursorColor: Colors.deepOrange,
                      obscureText: true,
                      obscuringCharacter: '*',
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: InputBorder.none,
                      ),
                      enabled: state ? false : true,
                    ),
                    MouseRegion(
                      cursor: _loginButtonEnable
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.forbidden,
                      child: GestureDetector(
                        child: state
                            ? const Text("Logging you in...",
                                style: TextStyle(color: Colors.grey))
                            : Text(
                                "Login",
                                style: _loginButtonEnable
                                    ? const TextStyle(color: Colors.orange)
                                    : const TextStyle(color: Colors.grey),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kynaara_frontend/business_logic/controller/home_screen_controller.dart';
import 'package:kynaara_frontend/data/repositories/session_manager.dart';
import 'package:kynaara_frontend/presentation/pages/admin_page.dart';
import 'package:kynaara_frontend/presentation/pages/sales_person_page.dart';
import 'package:kynaara_frontend/presentation/screens/login_screen.dart';
import 'package:kynaara_frontend/presentation/widgets/session_expired_dialog.dart';
import 'package:kynaara_frontend/presentation/widgets/user_details_dialog.dart';
import 'package:kynaara_frontend/utils/constants/ui_text_constants.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenController _homeScreenController;
  bool _checkSession = true;

  @override
  void initState() {
    super.initState();
    _homeScreenController = HomeScreenController(() {
      logoutUser(context);
    });

    checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBar(),
      ),
      body: _checkSession ? Container() : _homeBody(),
    );
  }

  Widget _appBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 10,
          child: Text(UITextConstants.appName),
        ),
        Expanded(
            flex: 1,
            child: Visibility(
              visible: _homeScreenController.loaderBloc.state == false,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.person),
                  ),
                  onTap: () {
                    if (context.mounted) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return UserDetailsDialog(
                              user: _homeScreenController.user!,
                              self: true,
                              callback: () {
                                if (context.mounted) {
                                  _homeScreenController.logout();
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const LoginScreen();
                                  }), ModalRoute.withName("/login"));
                                }
                              },
                            );
                          });
                    }
                  },
                ),
              ),
            ))
      ],
    );
  }

  Widget _homeBody() {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Visibility(
          child: Container(
            color: Color.fromARGB(150, 100, 100, 100),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2,)),
          ),
          visible: _homeScreenController.loaderBloc.state == true,
        ),
        _homeScreenController.user == null
            ? Container()
            : ((_homeScreenController.user!.userLevel >= 3)
                ? SalesPersonPage(logoutCallback: logoutUser, user: _homeScreenController.user!,)
                : AdminPage(logoutCallback: logoutUser, user: _homeScreenController.user!,))
      ],
    );
  }

  void checkSession() async {
    SessionManager sessionManager = SessionManager();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String token = sessionManager.getToken(sharedPreferences);
    if (token.isEmpty) {
      if (context.mounted) {
        logoutUser(context);
      }
    } else {
      setState(() {
        _checkSession = false;
      });
      _homeScreenController.getInfo(() {
        setState(() {});
      });
    }
  }
}

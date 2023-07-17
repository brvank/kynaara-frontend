import 'package:flutter/material.dart';
import 'package:kynaara_frontend/business_logic/controller/admin_page_controller.dart';
import 'package:kynaara_frontend/presentation/screens/login_screen.dart';
import 'package:kynaara_frontend/presentation/views/channels_table_view.dart';
import 'package:kynaara_frontend/presentation/views/users_table_view.dart';
import 'package:kynaara_frontend/presentation/widgets/session_expired_dialog.dart';

class AdminPage extends StatefulWidget {
  final Function logoutCallback;
  const AdminPage({Key? key, required this.logoutCallback}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late AdminPageController _adminPageController;
  int start = 0, size = 5, end = 0, total = 0;
  int selectedIndex = 0;

  List<Widget> tabViews = [];

  @override
  void initState() {
    super.initState();
    _adminPageController = AdminPageController((){widget.logoutCallback(context);});

    setUpTabViews();
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: sideNavigationTabs(),
          flex: 1,
        ),
        Expanded(child: tabViews[selectedIndex], flex: 10,)
      ],
    );
  }

  void setUpTabViews(){
    tabViews.add(Container(
      color: Colors.greenAccent,
      child: const Center(
        child: ChannelsTableView(),
      ),
    ));

    tabViews.add(Container(
      child: UsersTableView(),
    ));

    tabViews.add(Container(
      child: Text("Stats"),
    ));
  }

  Widget sideNavigationTabs(){
    return Container(
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Text("Manage Channels"),
            onTap: (){
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          GestureDetector(
            child: Text("Manage Users"),
            onTap: (){
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          GestureDetector(
            child: Text("Stats"),
            onTap: (){
              setState(() {
                selectedIndex = 2;
              });
            },
          )
        ],
      ),
    );
  }
}


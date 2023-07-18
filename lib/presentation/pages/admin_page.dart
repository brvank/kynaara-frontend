import 'package:flutter/material.dart';
import 'package:kynaara_frontend/business_logic/controller/admin_page_controller.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/screens/login_screen.dart';
import 'package:kynaara_frontend/presentation/views/channels_table_view.dart';
import 'package:kynaara_frontend/presentation/views/products_table_view.dart';
import 'package:kynaara_frontend/presentation/views/users_table_view.dart';
import 'package:kynaara_frontend/presentation/widgets/session_expired_dialog.dart';

class AdminPage extends StatefulWidget {
  final Function logoutCallback;
  final User user;
  const AdminPage({Key? key, required this.logoutCallback, required this.user})
      : super(key: key);

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
    _adminPageController = AdminPageController(() {
      widget.logoutCallback(context);
    });

    setUpTabViews();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: widget.user.userLevel == 1
              ? sideNavigationTabsForSuperAdmin()
              : sideNavigationTabsForAdmin(),
        ),
        Expanded(
          flex: 10,
          child: tabViews[selectedIndex],
        )
      ],
    );
  }

  void setUpTabViews() {
    if (widget.user.userLevel == 1) {
      //super admin
      tabViews.add(Container(
        color: Colors.greenAccent,
        child: Center(
          child: ChannelsTableView(
            user: widget.user,
          ),
        ),
      ));

      tabViews.add(Container(
        child: UsersTableView(
          user: widget.user,
        ),
      ));

      tabViews.add(Container(
        child: Text("Stats"),
      ));
    } else {
      tabViews.add(Container(
        color: Colors.greenAccent,
        child: Center(
          child: ProductsTableView(
            user: widget.user,
            salesPerson: false,
          ),
        ),
      ));

      tabViews.add(Container(
        child: UsersTableView(
          user: widget.user,
        ),
      ));

      tabViews.add(Container(
        child: Text("Stats"),
      ));
    }
  }

  Widget sideNavigationTabsForSuperAdmin() {
    return Container(
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Text("Manage Channels"),
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          GestureDetector(
            child: Text("Manage Users"),
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          GestureDetector(
            child: Text("Stats"),
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
          )
        ],
      ),
    );
  }

  Widget sideNavigationTabsForAdmin() {
    return Container(
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Text("Manage Products"),
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          GestureDetector(
            child: Text("Manage Sales Persons"),
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          GestureDetector(
            child: Text("Stats"),
            onTap: () {
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

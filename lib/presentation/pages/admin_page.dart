import 'package:flutter/material.dart';
import 'package:kynaara_frontend/business_logic/controller/admin_page_controller.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/screens/login_screen.dart';
import 'package:kynaara_frontend/presentation/views/channels_table_view.dart';
import 'package:kynaara_frontend/presentation/views/products_table_view.dart';
import 'package:kynaara_frontend/presentation/views/users_table_view.dart';
import 'package:kynaara_frontend/presentation/widgets/navigation_button_tab.dart';
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
      tabViews.add(Center(
        child: ChannelsTableView(
          user: widget.user,
        ),
      ));

      tabViews.add(Center(
        child: UsersTableView(
          user: widget.user,
        ),
      ));

      tabViews.add(const Center(child: Text("Coming Soon!")));

    } else {
      tabViews.add(Center(
        child: ProductsTableView(
          user: widget.user,
          salesPerson: false,
        ),
      ));

      tabViews.add(Center(
        child: UsersTableView(
          user: widget.user,
        ),
      ));

      tabViews.add(const Center(child: Text("Coming Soon!")));
    }
  }

  Widget sideNavigationTabsForSuperAdmin() {
    return Container(
      color: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NavigationButtonTab(text: "Manage Channels", callback: (){
            setState(() {
              selectedIndex = 0;
            });
          }, selected: selectedIndex == 0),
          NavigationButtonTab(text: "Manage Users", callback: (){
            setState(() {
              selectedIndex = 1;
            });
          }, selected: selectedIndex == 1),
          NavigationButtonTab(text: "Stats", callback: (){
            setState(() {
              selectedIndex = 2;
            });
          }, selected: selectedIndex == 2),
        ],
      ),
    );
  }

  Widget sideNavigationTabsForAdmin() {
    return Container(
      color: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NavigationButtonTab(text: "Manage Products", callback: (){
            setState(() {
              selectedIndex = 0;
            });
          }, selected: selectedIndex == 0),
          NavigationButtonTab(text: "Manage Users", callback: (){
            setState(() {
              selectedIndex = 1;
            });
          }, selected: selectedIndex == 1),
          NavigationButtonTab(text: "Stats", callback: (){
            setState(() {
              selectedIndex = 2;
            });
          }, selected: selectedIndex == 2),
        ],
      ),
    );
  }
}

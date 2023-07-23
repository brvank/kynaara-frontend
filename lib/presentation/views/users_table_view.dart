import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/business_logic/controller/users_table_view_controller.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/widgets/custom_button.dart';
import 'package:kynaara_frontend/presentation/widgets/user_dialog.dart';
import 'package:kynaara_frontend/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:kynaara_frontend/utils/constants/ui_text_constants.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';

class UsersTableView extends StatefulWidget {
  final User user;
  const UsersTableView({Key? key, required this.user}) : super(key: key);

  @override
  State<UsersTableView> createState() => _UsersTableViewState();
}

class _UsersTableViewState extends State<UsersTableView> {
  late UsersTableViewController _usersTableController;

  int start = 0, size = Constants.size, end = 0, total = 0;

  TextEditingController _userNameController = TextEditingController();
  String _userName = "";

  @override
  void initState() {
    super.initState();

    _usersTableController = UsersTableViewController(() {
      logoutUser(context);
    });

    getUsers();
  }

  void getUsers() {
    _usersTableController.getUsers(start, size, _userNameController.text,
        (start, end, total) {
      this.start = start;
      this.end = end;
      this.total = total;

      setState(() {
        Future.delayed(Duration.zero).then((value) {
          if (_usersTableController.users.isEmpty) {
            getPrev();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoaderBloc>(
            create: (context) {
              return _usersTableController.loaderBloc;
            },
          ),
          BlocProvider<MessageBloc>(
            create: (context) {
              return _usersTableController.messageBloc;
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
          builder: (context, state) {
            return BlocBuilder<LoaderBloc, bool>(builder: (context, state) {
              if (state == true) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      //all options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _userNameController,
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: "User Name",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orangeAccent)),
                              ),
                            ),
                          ),
                          CustomButton(
                            text: "Search",
                            callback: () {
                              _userName = _userNameController.text;
                              getUsers();
                            },
                          ),
                          CustomButton(
                            text: "Refresh",
                            callback: () {
                              getUsers();
                            },
                          ),
                          CustomButton(
                              text: "Add User",
                              callback: () {
                                addUserDialog();
                              })
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: TableTabs.headerTab(
                                  "S.No.", TabDirection.LEFT)),
                          Expanded(
                              flex: 2,
                              child: TableTabs.headerTab(
                                  "User Name", TabDirection.MID)),
                          Expanded(
                              flex: 2,
                              child: TableTabs.headerTab(
                                  "Full Name", TabDirection.MID)),
                          Expanded(
                              flex: 2,
                              child: TableTabs.headerTab(
                                  "Email", TabDirection.MID)),
                          Expanded(
                              flex: 1,
                              child: TableTabs.headerTab("", TabDirection.MID)),
                          Expanded(
                              flex: 1,
                              child:
                                  TableTabs.headerTab("", TabDirection.RIGHT)),
                        ],
                      ),

                      //all users
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _usersTableController.users.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.brown,
                                              width: 0.2))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child:
                                              TableTabs.tableTab("${i + 1}")),
                                      Expanded(
                                          flex: 2,
                                          child: TableTabs.tableTab(
                                              _usersTableController
                                                  .users[i].userName)),
                                      Expanded(
                                          flex: 2,
                                          child: TableTabs.tableTab(
                                              _usersTableController
                                                  .users[i].name)),
                                      Expanded(
                                          flex: 2,
                                          child: TableTabs.tableTab(
                                              _usersTableController
                                                  .users[i].email)),
                                      Expanded(
                                          flex: 1,
                                          child: TableTabs.buttonTableTab(
                                            "Edit",
                                            () {
                                              updateUserDialog(
                                                  _usersTableController
                                                      .users[i]);
                                            },
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: TableTabs.buttonTableTab(
                                            "Delete",
                                            () {
                                              deleteUserDialog(
                                                  _usersTableController
                                                      .users[i].id);
                                            },
                                          )),
                                    ],
                                  ),
                                );
                              })),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            text: "Prev",
                            callback: () {
                              getPrev();
                            },
                            active: (start - size) >= 0,
                          ),
                          Text("$end/$total"),
                          CustomButton(
                            text: "Next",
                            callback: () {
                              getNext();
                            },
                            active: (start + size) < total,
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
            });
          },
        ));
  }

  void getPrev() {
    if (start != 0) {
      if ((start - size) >= 0) {
        start = start - size;

        getUsers();
      }
    }
  }

  void getNext() {
    if (end <= total && total != 0) {
      if ((start + size) < total) {
        start = start + size;

        getUsers();
      }
    }
  }

  void addUserDialog() {
    User user = User(
        id: -1,
        name: "",
        userName: "",
        email: "",
        userLevel: -1,
        alterSuperAdmin: false,
        alterAdmin: false,
        alterSalesPerson: false,
        alterChannel: false,
        alterProduct: false);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UserDialog(
            callback: (User user) async {
              bool result = await _usersTableController.addUser(user);
              await Future.delayed(Duration.zero);
              if (result) {
                getUsers();
              }
              return result;
            },
            edit: false,
            user: user,
            self: widget.user,
          );
        });
  }

  void updateUserDialog(User user) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UserDialog(
            callback: (User user) async {
              bool result = await _usersTableController.updateUser(user);
              await Future.delayed(Duration.zero);
              if (result) {
                getUsers();
              }

              return result;
            },
            edit: true,
            user: user,
            self: widget.user,
          );
        });
  }

  void deleteUserDialog(int id) async {
    bool? result = await showDialog(
        context: context,
        builder: (context) {
          return const DeleteConfirmationDialog();
        });

    if (result != null && result == true) {
      bool result = await _usersTableController.deleteUser(id);
      await Future.delayed(Duration.zero);
      if (result) {
        getUsers();
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/business_logic/controller/users_table_view_controller.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/widgets/user_dialog.dart';
import 'package:kynaara_frontend/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';

class UsersTableView extends StatefulWidget {
  final User user;
  const UsersTableView({Key? key, required this.user}) : super(key: key);

  @override
  State<UsersTableView> createState() => _UsersTableViewState();
}

class _UsersTableViewState extends State<UsersTableView> {
  late UsersTableViewController _usersTableController;

  int start = 0, size = 2, end = 0, total = 0;

  TextEditingController userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _usersTableController = UsersTableViewController(() {
      logoutUser(context);
    });

    getUsers();
  }

  void getUsers() {
    _usersTableController.getUsers(
        start, size, userNameController.text, (start, end, total) {
      this.start = start;
      this.end = end;
      this.total = total;

      setState(() {

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
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.all(8),
                  color: Colors.blue,
                  child: Column(
                    children: [
                      //all options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                addUserDialog();
                              },
                              child: Text("Add User"))
                        ],
                      ),

                      //all headings
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("S.No.")),
                          Expanded(flex: 2, child: Text("User Name")),
                          Expanded(flex: 2, child: Text("Full Name")),
                          Expanded(flex: 2, child: Text("Email")),
                          Expanded(flex: 1, child: Text("")),
                          Expanded(flex: 1, child: Text("")),
                        ],
                      ),

                      //all users
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                              _usersTableController.users.length,
                              itemBuilder: (context, i) {
                                return Row(
                                  children: [
                                    Expanded(
                                        flex: 1, child: Text("${i+1}")),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_usersTableController
                                            .users[i].userName)),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_usersTableController
                                            .users[i].name)),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_usersTableController
                                            .users[i].email)),
                                    Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          child: Text("Edit"),
                                          onPressed: () {
                                            updateUserDialog(_usersTableController.users[i]);
                                          },
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          child: Text("Delete"),
                                          onPressed: () {
                                            deleteUserDialog(_usersTableController.users[i].id);
                                          },
                                        )),
                                  ],
                                );
                              })),
                      Row(
                        children: [
                          TextButton(
                            child: Text("Refresh"),
                            onPressed: () {
                              getUsers();
                            },
                          ),
                          TextButton(
                            child: Text("Prev"),
                            onPressed: () {
                              getPrev();
                            },
                          ),
                          Text("$end/$total"),
                          TextButton(
                            child: Text("Next"),
                            onPressed: () {
                              getNext();
                            },
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

  void getPrev(){
    if(start != 0){
      if((start - size) >= 0){
        start = start - size;

        getUsers();
      }
    }
  }

  void getNext(){
    if(end <= total && total != 0){
      if((start + size) < total){
        start = start + size;

        getUsers();
      }
    }
  }

  void addUserDialog() {
    User user = User(id: -1, name: "", userName: "", email: "", userLevel: -1, alterSuperAdmin: false, alterAdmin: false, alterSalesPerson: false, alterChannel: false, alterProduct: false);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UserDialog(
              callback: (User user) async {
                bool result =
                await _usersTableController.addUser(user);
                await Future.delayed(Duration.zero);
                if (result) {
                  getUsers();
                }
                return result;
              },
              edit: false,
              user: user,
          self: widget.user,);
        });
  }

  void updateUserDialog(User user){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return UserDialog(
            callback: (User user) async {
              bool result = await _usersTableController.updateUser(user);
              await Future.delayed(Duration.zero);
              if(result){
                getUsers();
              }

              return result;
            },
            edit: true,
            user: user,
            self: widget.user,
          );
        }
    );
  }

  void deleteUserDialog(int id) async {
    bool? result = await showDialog(
        context: context,
        builder: (context){
          return DeleteConfirmationDialog();
        }
    );

    if(result != null && result == true){
      bool result = await _usersTableController.deleteUser(id);
      await Future.delayed(Duration.zero);
      if(result){
        getUsers();
      }
    }
  }
}

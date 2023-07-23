import 'package:flutter/material.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';

class UserDialog extends StatefulWidget {
  final Function callback;
  final bool edit;
  final User user;
  final User self;
  const UserDialog(
      {Key? key,
      required this.callback,
      required this.edit,
      required this.user,
      required this.self})
      : super(key: key);

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final TextEditingController _userNameController = TextEditingController(),
      _userUserNameController = TextEditingController(),
      _userPasswordController = TextEditingController(),
      _userEmailController = TextEditingController();

  bool loading = false;
  bool allGood = false;

  List<String> userTypes = [];
  List<DropdownMenuItem> dropdownMenuItems = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _userNameController.text = widget.user.name;
    _userEmailController.text = widget.user.email;
    _userUserNameController.text = widget.user.userName;

    _userNameController.addListener(() {
      checkAllGood();
    });

    _userUserNameController.addListener(() {
      checkAllGood();
    });

    _userPasswordController.addListener(() {
      checkAllGood();
    });

    _userEmailController.addListener(() {
      checkAllGood();
    });

    userTypes.add("Select User Type");
    dropdownMenuItems.add(const DropdownMenuItem(
      value: "Select User Type",
      child: Text("Select User Type"),
    ));

    if (widget.self.alterSuperAdmin) {
      userTypes.add(superAdmin);
      dropdownMenuItems.add(DropdownMenuItem(
        value: superAdmin,
        child: Text(superAdmin),
      ));
    }

    if (widget.self.alterAdmin) {
      userTypes.add(admin);
      dropdownMenuItems.add(DropdownMenuItem(
        value: admin,
        child: Text(admin),
      ));
    }

    if (widget.self.alterSalesPerson) {
      userTypes.add(salesPerson);
      dropdownMenuItems.add(DropdownMenuItem(
        value: salesPerson,
        child: Text(salesPerson),
      ));
    }

    for(int i=0;i<userTypes.length;i++){
      if(widget.user.userLevel == userLevel(userTypes[i])){
        selectedIndex = i;
        break;
      }
    }

    checkAllGood();
  }

  void checkAllGood() {
    if (_userNameController.text.isNotEmpty &&
        _userUserNameController.text.isNotEmpty &&
        (!widget.edit || _userPasswordController.text.isNotEmpty) &&
        _userEmailController.text.isNotEmpty && (selectedIndex != 0) ) {
      allGood = true;
    } else {
      allGood = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.6,
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                child: TextField(
                  autofocus: true,
                  cursorColor: Colors.deepOrange,
                  controller: _userNameController,
                  decoration: const InputDecoration(
                      labelText: "User Full Name",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.orangeAccent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.orangeAccent))),
                  enabled: !loading,
                ),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: TextField(
                          autofocus: true,
                          cursorColor: Colors.deepOrange,
                          controller: _userUserNameController,
                          decoration: const InputDecoration(
                              labelText: "User Name",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orangeAccent)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orangeAccent))),
                          enabled: !loading,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: TextField(
                          autofocus: true,
                          cursorColor: Colors.deepOrange,
                          controller: _userEmailController,
                          decoration: const InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orangeAccent)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orangeAccent))),
                          enabled: !loading,
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: DropdownButton(
                        borderRadius: BorderRadius.circular(4),
                        underline: Container(),
                        items: dropdownMenuItems,
                        onChanged: (state) {
                          if (state is String) {
                            selectedIndex = userTypes.indexOf(state);
                            checkAllGood();
                          }
                        },
                        value: userTypes[selectedIndex],
                        isExpanded: true,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Visibility(
                      visible: !widget.edit,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: TextField(
                          autofocus: true,
                          cursorColor: Colors.deepOrange,
                          controller: _userPasswordController,
                          decoration: const InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orangeAccent)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orangeAccent))),
                          enabled: !loading,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            if (!loading) {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  loading ? Colors.grey : Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            if (!loading && allGood) {
                              setState(() {
                                loading = true;
                              });
                              widget.user.name = _userNameController.text;
                              widget.user.userName =
                                  _userUserNameController.text;
                              widget.user.email = _userEmailController.text;
                              if (!widget.edit) {
                                widget.user.password =
                                    _userPasswordController.text;
                              }
                              int? level = userLevel(userTypes[selectedIndex]);
                              if (level != null) {
                                widget.user.userLevel = level;
                                bool? result =
                                    await widget.callback(widget.user);
                                setState(() {
                                  loading = false;
                                });
                                if (result != null && result == true) {
                                  Navigator.pop(context);
                                }
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: !loading && allGood
                                  ? Colors.orangeAccent
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  )
                                : Text(
                                    widget.edit ? "Update User" : "Add User",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}

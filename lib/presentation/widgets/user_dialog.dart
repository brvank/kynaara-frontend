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
      required this.user, required this.self})
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

  List<String> userTypes = [];
  List<DropdownMenuItem> dropdownMenuItems = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _userNameController.text = widget.user.name;
    _userEmailController.text = widget.user.email;

    userTypes.add("Select User Type");
    dropdownMenuItems.add(DropdownMenuItem(child: Text("Select User Type"), value: "Select User Type",));

    if(widget.self.alterSuperAdmin){
      userTypes.add(superAdmin);
      dropdownMenuItems.add(DropdownMenuItem(child: Text(superAdmin), value: superAdmin,));
    }

    if(widget.self.alterAdmin){
      userTypes.add(admin);
      dropdownMenuItems.add(DropdownMenuItem(child: Text(admin), value: admin,));
    }

    if(widget.self.alterSalesPerson){
      userTypes.add(salesPerson);
      dropdownMenuItems.add(DropdownMenuItem(child: Text(salesPerson), value: salesPerson,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                visible: !loading,
              )
            ],
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.deepOrange,
            controller: _userNameController,
            decoration: const InputDecoration(
              labelText: "User Full Name",
              border: InputBorder.none,
            ),
            enabled: !loading,
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.deepOrange,
            controller: _userUserNameController,
            decoration: const InputDecoration(
              labelText: "User Name",
              border: InputBorder.none,
            ),
            enabled: !loading,
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.deepOrange,
            controller: _userEmailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: InputBorder.none,
            ),
            enabled: !loading,
          ),
          Visibility(child: TextField(
            autofocus: true,
            cursorColor: Colors.deepOrange,
            controller: _userPasswordController,
            decoration: const InputDecoration(
              labelText: "Password",
              border: InputBorder.none,
            ),
            enabled: !loading,
          ), visible: !widget.edit,),
          DropdownButton(items: dropdownMenuItems, onChanged: (state){
            if(state is String){
              setState(() {
                selectedIndex = userTypes.indexOf(state);
              });
            }
          }, value: userTypes[selectedIndex], isExpanded: true,),
          TextButton(
            child: loading
                ? CircularProgressIndicator()
                : (widget.edit ? Text("Update User") : Text("Add User")),
            onPressed: () async {
              if (!loading) {
                setState(() {
                  loading = true;
                });
                widget.user.name = _userNameController.text;
                widget.user.userName = _userUserNameController.text;
                widget.user.email = _userEmailController.text;
                if(!widget.edit){
                  widget.user.password = _userPasswordController.text;
                }
                int? level = userLevel(userTypes[selectedIndex]);
                if(level != null){
                  widget.user.userLevel = level;
                  bool? result = await widget.callback(widget.user);
                  setState(() {
                    loading = false;
                  });
                  if (result != null && result == true) {
                    Navigator.pop(context);
                  }
                }
              }
            },
          )
        ],
      ),
    );
    ;
  }
}

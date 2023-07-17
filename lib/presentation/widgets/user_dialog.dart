import 'package:flutter/material.dart';
import 'package:kynaara_frontend/data/model/user.dart';

class UserDialog extends StatefulWidget {
  final Function callback;
  final bool edit;
  final User user;
  const UserDialog(
      {Key? key,
      required this.callback,
      required this.edit,
      required this.user})
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

  @override
  void initState() {
    super.initState();

    _userNameController.text = widget.user.name;
    _userEmailController.text = widget.user.email;
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
                bool? result = await widget.callback(widget.user);
                setState(() {
                  loading = false;
                });
                if (result != null && result == true) {
                  Navigator.pop(context);
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

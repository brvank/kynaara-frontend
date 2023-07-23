import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kynaara_frontend/presentation/widgets/custom_button.dart';

class CustomSelectButton extends StatefulWidget {
  final String text;
  final String selectedText;
  final String labelText;
  final Function callback;
  final Color backgroundColor;
  final Color textColor;
  final Color focusBackgroundColor;
  final Color focusTextColor;
  final bool active;

  const CustomSelectButton(
      {super.key,
      required this.selectedText,
      required this.labelText,
      required this.text,
      required this.callback,
      this.textColor = Colors.white,
      this.focusTextColor = Colors.white,
      this.focusBackgroundColor = Colors.orangeAccent,
      this.backgroundColor = Colors.grey,
      this.active = true});

  @override
  State<CustomSelectButton> createState() => _CustomSelectButtonState();
}

class _CustomSelectButtonState extends State<CustomSelectButton> {
  bool hover = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textEditingController.text = widget.selectedText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(
            width: 256,
            child: TextField(
              controller: _textEditingController,
              enabled: false,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.all(8),
                labelText: widget.labelText,
                border: const OutlineInputBorder(borderSide: BorderSide()),
              ),
            ),
          ),
          CustomButton(text: widget.text, callback: (){widget.callback();}),
        ],
      ),
    );
  }
}

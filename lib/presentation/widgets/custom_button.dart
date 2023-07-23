import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Function callback;
  final Color backgroundColor;
  final Color textColor;
  final Color focusBackgroundColor;
  final Color focusTextColor;
  final bool active;

  const CustomButton({super.key, required this.text, required this.callback, this.textColor = Colors.white, this.focusTextColor = Colors.white, this.focusBackgroundColor = Colors.orangeAccent, this.backgroundColor = Colors.grey, this.active = true});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {

  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_){
        setState(() {
          if(widget.active) {
            hover = true;
          }
        });
      },
      onExit: (_){
        setState(() {
          if(widget.active) {
            hover = false;
          }
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          widget.callback();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: hover ? widget.focusBackgroundColor : widget.backgroundColor,
            borderRadius: BorderRadius.circular(4)
          ),
          child: Text(widget.text, style: TextStyle(color: widget.active ? (hover ? widget.focusTextColor : widget.textColor) : Colors.black26),),
        ),
      ),
    );
  }
}

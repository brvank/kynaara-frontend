import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationButtonTab extends StatefulWidget {
  final String text;
  final Function callback;
  final bool selected;
  const NavigationButtonTab({super.key, required this.text, required this.callback, required this.selected});

  @override
  State<NavigationButtonTab> createState() => _NavigationButtonTabState();
}

class _NavigationButtonTabState extends State<NavigationButtonTab> {

  bool hover = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_){
        setState(() {
          hover = true;
        });
      },
      onExit: (_){
        setState(() {
          hover = false;
        });
      },
      child: GestureDetector(
        child: AnimatedContainer(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: hover ? Colors.orangeAccent : widget.selected ? Colors.orangeAccent : Colors.grey
          ),
          duration: const Duration(milliseconds: 200),
          child: Text(widget.text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        ),
        onTap: (){
          widget.callback();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SalesPersonPage extends StatefulWidget {
  final Function logoutCallback;
  const SalesPersonPage({Key? key, required this.logoutCallback}) : super(key: key);

  @override
  State<SalesPersonPage> createState() => _SalesPersonPageState();
}

class _SalesPersonPageState extends State<SalesPersonPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Sales person page"),
    );
  }
}

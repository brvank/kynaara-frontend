import 'package:flutter/material.dart';

class RedirectScreen extends StatefulWidget {
  const RedirectScreen({super.key});

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("redirecting"));
  }
}

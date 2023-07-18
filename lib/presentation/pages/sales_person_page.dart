import 'package:flutter/material.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/views/products_table_view.dart';

class SalesPersonPage extends StatefulWidget {
  final Function logoutCallback;
  final User user;
  const SalesPersonPage({Key? key, required this.logoutCallback, required this.user}) : super(key: key);

  @override
  State<SalesPersonPage> createState() => _SalesPersonPageState();
}

class _SalesPersonPageState extends State<SalesPersonPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ProductsTableView(salesPerson: true, user: widget.user,)
    );
  }
}

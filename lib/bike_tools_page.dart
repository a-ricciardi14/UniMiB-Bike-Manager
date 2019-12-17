import 'package:flutter/material.dart';

import 'model/bike.dart';
import 'model/user.dart';

class BikeToolsPage extends StatefulWidget {
  final User user;
  final Bike bike;

  BikeToolsPage({Key key, @required this.user, @required this.bike}) : super(key: key);

  @override
  _BikeToolsPageState createState() => _BikeToolsPageState();
}

class _BikeToolsPageState extends State<BikeToolsPage> {
  User get _user => widget.user;
  Bike get _rack => widget.bike;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

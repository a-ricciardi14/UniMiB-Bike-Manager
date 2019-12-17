import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/model/user.dart';

class AddRack extends StatefulWidget {

  final User user;
  AddRack({Key key, @required this.user}) :
      assert (user != null),
        super(key: key);

  @override
  _AddRackState createState() => _AddRackState();
}

class _AddRackState extends State<AddRack> {
  User get _user => widget.user;


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

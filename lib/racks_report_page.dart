import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/model/rack.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';

class RacksReportPage extends StatefulWidget {
  final User user;

  RacksReportPage({Key key, @required this.user}): assert(user != null), super(key: key);

  @override
  _RacksReportPage createState() => _RacksReportPage();
}

class _RacksReportPage extends State<RacksReportPage> {

  User get _user => widget.user;


  bool _request = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _controllerDesc = new TextEditingController();

  Rack _rackSelected;
  List _rack = List();

  Future<void> getRackData() async{
    var _rackData = await fetchRackList();

    setState(() {
      _rack = _rackData.racks;
    });
  }

  @override
  void dispose() {
    _controllerDesc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _request = false;
    this.getRackData();

  }

  @override
  Widget build(BuildContext context) {
    String description;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text(S.of(context).rack_report),
      ),
      drawer: MyDrawer(user: _user),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new DropdownButton(
                  isExpanded: true,
                  value: _rackSelected,
                  items: _rack.map((rack){
                    return new DropdownMenuItem(
                      child: Row(
                        children: <Widget>[
                          new Icon(Icons.apps),
                          new SizedBox(width: 10.0,),
                          new Text(rack.locationDescription),
                        ],
                      ),
                      value: rack,
                    );
                  }).toList(),
                  hint: new Text("Seleziona Rastrelliera"),
                  onChanged: (newVal) {
                    print("You Selected: " + newVal.id.toString());
                    setState(() {
                      _rackSelected = newVal;
                    });
                  }
              ),
              SizedBox(height: 12.0,),
              new TextFormField(
                decoration:
                InputDecoration(
                    labelText:
                      S.of(context).description,
                      border:
                      new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).desc_empty;
                  } else {
                    description = value;
                  }
                },
              ),
              SizedBox(height: 15.0,),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 100.0,
                  child: RaisedButton(
                    color: Colors.red[600],
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)
                    ),
                    child: _request
                        ? CircularProgressIndicator()
                        : Text(S.of(context).send,style: TextStyle(color: Colors.white),),
                    onPressed: _request ? null : () {
                      if (_formKey.currentState.validate()) {
                        setState(() => _request = true);
                        postReport('Rack: '+_rackSelected.id.toString(), description, _user.mEmail).then((value) {
                          showErrorDialog(context, S.of(context).success,
                              S.of(context).rep_received);
                          setState(() => _request = false);
                        }).catchError((e) {
                          showErrorDialog(context, 'Ops!',
                              S.of(context).rep_failed);
                          setState(() => _request = false);
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

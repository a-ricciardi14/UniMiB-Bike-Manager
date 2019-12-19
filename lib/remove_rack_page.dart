import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/model/rack.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';

import 'dart:async';

//TODO: Implementare DropDownMenù per visualizzare la lista di rastrelliere (funzionante, ma con errore => [ERROR:flutter/lib/ui/ui_dart_state.cc(157)] Unhandled Exception: type 'int' is not a subtype of type 'String'.

class RemoveRack extends StatefulWidget {

  final User user;

  RemoveRack({Key key, @required this.user}) :
        assert (user != null),
        super(key: key);

  @override
  _RemoveRackState createState() => _RemoveRackState();
}

class _RemoveRackState extends State<RemoveRack> {
  User get _user => widget.user;

  final _formKey = GlobalKey<FormState>();
  bool _request = false;

  TextEditingController _controller = new TextEditingController();

  Rack _rackSelected;
  List _rack = List();

  Future<void> getRackData() async{
    var _rackData = await fetchRackList();

    setState(() {
      _rack = _rackData.racks;
    });
  }

  @override
  void dispose(){
    _controller.dispose();
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text(S.of(context).remove_rack),
      ),
      drawer: MyDrawer(user: _user),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: new Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                onChanged: (newVal){
                  setState(() {
                    _rackSelected = newVal;
                  });
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
                        : Text("Salva",  style: TextStyle(color: Colors.white),),
                    onPressed: _request ? null : () {
                      if (_formKey.currentState.validate()) {
                        setState(() => _request = true);

                        deleteRack(_rackSelected.id.toString()).then((value) {
                          showErrorDialog(context, S.of(context).success,
                              S.of(context).rack_removed);
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

import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';

class RacksReportPage extends StatefulWidget {
  final User user;

  RacksReportPage({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  _RacksReportPage createState() => _RacksReportPage();
}

class _RacksReportPage extends State<RacksReportPage> {
  final _formKey = GlobalKey<FormState>();
  bool _request = false;
  User get _user => widget.user;
  String qrCode = '';
  TextEditingController controller = new TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _request = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String rackId;
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
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      controller: controller,
                      decoration:
                      InputDecoration(
                        labelText:
                          S.of(context).rack_code,
                          border:
                            new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return S.of(context).rack_empty;
                        } else {
                          rackId = value;
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: scan,
                  )
                ],
              ),
              SizedBox(height: 12.0,),
              TextFormField(
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
              SizedBox(
                height: 15.0,
              ),
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

                        postReport(rackId, description).then((value) {
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

  //Funzione per scannerizare il qrcode
  Future scan() async {
    try {
      String result = await BarcodeScanner.scan();
      setState(() => this.qrCode = result);
      setState(() => this.controller.text = result);

      /*await BarcodeScanner.scan().then((value) => setState((){
        this.controller.text = value;
      }));*/
    } on PlatformException catch (e) {
      //Errore permessi non concessi
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.qrCode = 'Permessi camera negati';
        });
      } else {
        setState(() => this.qrCode = '$e');
      }
      //Errore di chiusura della fotocamera prima che il codice possa essere catturato
    } on FormatException {
      setState(() => this.qrCode = 'Non sono riuscito a leggere nulla');
    } catch (e) {
      setState(() => this.qrCode = '$e');
    }
  }
}

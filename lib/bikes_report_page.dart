import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';

class BikesReportPage extends StatefulWidget {
  final User user;

  BikesReportPage({Key key, @required this.user}): assert(user != null), super(key: key);

  @override
  _BikesReportPage createState() => _BikesReportPage();
}

class _BikesReportPage extends State<BikesReportPage> {
  User get _user => widget.user;


  final _formKey = GlobalKey<FormState>();
  bool _request = false;

  String qrCode = '';
  TextEditingController idController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _request = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String bikeId;
    String description;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text(S.of(context).bike_report),
      ),
      drawer: MyDrawer(user: _user),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  Flexible(
                    child: new TextFormField(
                      controller: idController,
                      decoration:
                          InputDecoration(
                              labelText:
                                S.of(context).bikeCode,
                                border:
                                new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                ),
                          ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return S.of(context).bike_empty;
                        } else {
                          bikeId = value;
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
              new TextFormField(
                controller: descController,
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

                        postReport('Bike: '+bikeId, description, _user.mEmail).then((value){
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
      setState(() => this.idController.text = result);

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

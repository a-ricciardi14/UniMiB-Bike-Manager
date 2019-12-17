import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'dart:async';
import 'package:flutter/services.dart';



class RemoveBike extends StatefulWidget {

  final User user;
  RemoveBike({Key key, @required this.user}) :
        assert (user != null),
        super(key: key);

  @override
  _RemoveBikeState createState() => _RemoveBikeState();
}

class _RemoveBikeState extends State<RemoveBike> {
  User get _user => widget.user;

  final _formKey = GlobalKey<FormState>();
  bool _request = false;
  String qrCode = '';

  TextEditingController _controller = new TextEditingController();

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _request = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String bikeId = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text(S.of(context).remove_bike),
      ),
      drawer: MyDrawer(user: _user),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: new Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              new Row(
                children: <Widget>[
                  new Flexible(
                    child: new TextFormField(
                      controller: _controller,
                      decoration:
                      InputDecoration(
                        labelText:
                        S.of(context).bike_code,
                        border:
                        new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return S.of(context).rack_empty;
                        } else {
                          bikeId = value;
                        };
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: scan,
                  )
                ],
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
                      child: Text('Salva', style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        if(_formKey.currentState.validate()){

                          fetchBikeInfo(bikeId).then((_bike){
                            setState(() => _request = true);

                            print("Bike State: " + _bike.bikeState);

                            switch(_bike.bikeState){

                              case "Disponbile":{
                                print('This is BIKE_ID: ' + bikeId);
                                deleteBike(bikeId).then((value){
                                  showErrorDialog(context, S.of(context).bike_received, "Bicicletta eliminata!");
                                }).catchError((e){
                                  showErrorDialog(context, "Ops!", S.of(context).remove_failed);
                                });
                              }
                              break;

                              case "Prenotata":{
                                print("This is BIKE_ID: " + bikeId);
                                setState(() {
                                  _bike.bikeState = 1;
                                  print("This is BIKE_State: " + _bike.bikeState);
                                  deleteBike(bikeId).then((value){
                                    showErrorDialog(context, S.of(context).bike_received, "Bicicletta eliminata!");
                                  }).catchError((e){
                                    showErrorDialog(context, "Ops!", S.of(context).remove_failed);
                                  });
                                });
                              }
                              break;

                              case "Noleggiata":{
                                showErrorDialog(context, S.of(context).bike_not_avaiable, "Bicicletta in noleggio!");
                                setState(() => _request = false);
                              }
                              break;

                              case "Smarrita":{
                                showErrorDialog(context, S.of(context).bike_not_avaiable, "Bicicletta smarrita!");
                                setState(() => _request = false);
                              }
                              break;

                              case "Manutenzione":{
                                showErrorDialog(context, S.of(context).bike_not_avaiable, "Bicicletta in manutenzione");
                                setState(() => _request = false);
                              }
                              break;
                            }
                          }).catchError((e){
                            showErrorDialog(context, "OPS!", "Failed to manage bike!");
                            setState(() => _request = false);
                          });
                        }
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Funzione per scannerizare il qrcode del rack
  Future scan() async {
    try {
      String result = await BarcodeScanner.scan();
      setState(() => this.qrCode = result);
      setState(() => this._controller.text = result);

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

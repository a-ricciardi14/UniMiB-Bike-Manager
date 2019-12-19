import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:flutter/services.dart';

import 'functions/requests.dart';
import 'generated/i18n.dart';

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

  final _formKey = GlobalKey<FormState>();
  Future<Position> currentLocation;
  bool _request = false;
  String qrCode = '';

  TextEditingController _controllerId = new TextEditingController();
  TextEditingController _controllerCapacity = new TextEditingController();
  TextEditingController _controllerLocatDesc = new TextEditingController();
  TextEditingController _controllerStreetAddress = new TextEditingController();


  //funzione uguale a quella presente in map
  Future<Position> fetchLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }


  @override
  void dispose(){
    _controllerId.dispose();
    _controllerCapacity.dispose();
    _controllerLocatDesc.dispose();
    _controllerStreetAddress.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    currentLocation = fetchLocation();
    _request = false;
  }


  @override
  Widget build(BuildContext context)  {

    String _rackId;
    int _capacity;
    String _locatDesc;

    Position _currentPosition;

    //TODO: DA CONFERMARE!
    String _streetAddress;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text(S.of(context).add_rack),
      ),
      drawer: MyDrawer(user: _user),
      body: RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: new Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: _controllerId,
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
                            return S.of(context).bike_empty;
                          } else {
                            _rackId = value;
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
                SizedBox(height: 15.0,),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _controllerCapacity,
                    decoration:
                    InputDecoration(
                      labelText:
                      S.of(context).rack_capacity,
                      border:
                      new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        _capacity = null;
                      } else {
                        if(_controllerCapacity.text.length <= 10){
                          _capacity = int.parse(value);
                        }else{
                          return S.of(context).wrong;
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 15.0,),
                Flexible(
                  child: TextFormField(
                    controller: _controllerLocatDesc,
                    decoration:
                    InputDecoration(
                      labelText:
                      S.of(context).rack_locatDesc + " es: Rastrelliera U7",
                      border:
                      new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.of(context).wrong;
                      } else {
                        _locatDesc = value;
                      }
                    },
                  ),
                ),
                SizedBox(height: 15.0,),

//TODO: Creare label per il valore StreetAddress della rastrelliera
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "---",
                            style: TextStyle(fontSize: 22.0, color: Colors.black,),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                          : Text("Salva",style: TextStyle(color: Colors.white),),
                      onPressed: _request ? null : () {
                        if (_formKey.currentState.validate()) {
                          setState(() => _request = true);
                          addRack(int.parse(_rackId), _capacity, _locatDesc, _currentPosition).then((value) {
                            showErrorDialog(context, S.of(context).success,
                                S.of(context).add_bike);
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
        onRefresh: (){
          return _onRefresh();
        },
      ),
    );
  }

  //Funzione per scannerizare il qrcode
  Future scan() async {
    try {
      String result = await BarcodeScanner.scan();
      setState(() => this.qrCode = result);
      setState(() => this._controllerId.text = result);

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

  Future<void> _onRefresh() async {
    setState(() {
      currentLocation = fetchLocation();
    });
  }
}

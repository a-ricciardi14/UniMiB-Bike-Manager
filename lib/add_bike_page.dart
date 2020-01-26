import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'package:unimib_bike_manager/model/rack.dart';
import 'package:unimib_bike_manager/model/user.dart';

class AddBike extends StatefulWidget {

  final User user;

  AddBike({Key key, @required this.user}) : assert (user != null), super(key: key);

  @override
  _AddBikeState createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {

  User get _user => widget.user;

  final _formKey = GlobalKey<FormState>();
  bool _request = false;
  String qrCode = '';

  TextEditingController _controllerId = new TextEditingController();
  TextEditingController _controllerUnlockCode = new TextEditingController();
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
    _controllerId.dispose();
    _controllerUnlockCode.dispose();
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

    String bikeId;
    int _unlockCode;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text(S.of(context).add_bike),
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
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      controller: _controllerId,
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
              SizedBox(height: 15.0,),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      controller: _controllerUnlockCode,
                      decoration:
                      InputDecoration(
                        labelText:
                        S.of(context).unlock_code,
                        border:
                        new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          _unlockCode = null;
                        } else {
                          if(_controllerUnlockCode.text.length < 4){
                            return S.of(context).pass_wrong;
                          }else{
                            _unlockCode = int.parse(value);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
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
                    setState(() {
                      _rackSelected = newVal;
                    });
                  }
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
                        : Text("Salva", style: TextStyle(color: Colors.white),),
                    onPressed: _request ? null : () {
                      if (_formKey.currentState.validate()) {
                        setState(() => _request = true);
                        addBike(bikeId, _unlockCode, _rackSelected.id.toString()).then((value) {
                          showErrorDialog(context, S.of(context).success,
                              S.of(context).add_bike);
                          setState(() => _request = false);
                        }).catchError((e) {
                          showErrorDialog(context, 'Ops!',
                              'Failed to add Bike to Rack');
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
}

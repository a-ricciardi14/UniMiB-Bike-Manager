import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';

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
  Bike get _bike => widget.bike;

  String _bikeDisp = '';

  bool _request = false;


  TextEditingController _editingController = new TextEditingController();

  _unLockDialog(BuildContext context, int _cod) async {
    _editingController.text = '';
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text("Modifica parametro: "),
            content: new TextField(
              keyboardType: TextInputType.number,
              maxLength: 4,
              controller: _editingController,
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  textColor: Colors.red[600],
                  child: Text("Salva"),
                  onPressed: _request ? null : () {
                    if (_editingController.text != null) {
                      setState(() => _request = true);
                      setBikeUnCode(_cod, _bike).then((value){
                        showErrorDialog(context, S.of(context).success,
                            'Parametro modificato!');
                        setState(() => _request = false);
                      }).catchError((e) {
                        showErrorDialog(context, 'Ops!',
                            S.of(context).service_exception);
                        setState(() => _request = false);
                      });
                    } else {
                      throw Exception('_editingController == null');
                    }
                  }
              )
            ],
          );
        }
        );
  }

  _dispoDialog(BuildContext context, String _disp) async {
    int _selectedDisp;
    List<int> _listDisp = [1, 4, 5];

    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text("Modifica disponibilità: "),
            content: new DropdownButton(
              isExpanded: true,
              hint: Text('Scegli disponibilità'),
              value: _selectedDisp,
              items: _listDisp.map((value){
                return new DropdownMenuItem(
                    value: value,
                    child: value == 1 ? new Text('Disponibile')
                        : value == 4 ? new Text('Smarrita')
                        : value == 5 ? new Text('Manutenzione')
                        : null
                );
              }).toList(),
              onChanged: (int newValue){
                setState(() {
                  _selectedDisp = newValue;
                });
                },
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  textColor: Colors.red[600],
                  child: Text("Salva"),
                  onPressed: _request ? null : () {
                    if (_editingController.text != null) {
                      setState(() => _request = true);
                      setBikeDisp(_selectedDisp, _bike).then((value){
                        showErrorDialog(context, S.of(context).success,
                            'Parametro modificato!');
                        setState(() => _request = false);
                      }).catchError((e) {
                        showErrorDialog(context, 'Ops!',
                            S.of(context).service_exception);
                        setState(() => _request = false);
                      });
                    } else {
                      throw Exception('_editingController == null');
                    }
                  }
              )
            ],
          );
        }
    );
  }


  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _request = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            'Bicicletta: ' +
                _bike.id.toString()
        ),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      backgroundColor: Colors.grey[300],

      body: Container(
          child: ListView(
            children: <Widget>[

              //Bike Rack Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.apps, color: Colors.black,),
                    title: Text("Codice rastrelliera: "),
                    subtitle: Text(_bike.rack.id.toString()),
                  ),
                ),
              ),

              //Bike UnlockCode Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: (){
                    _unLockDialog(context, _bike.unlockCode);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.lock, color: Colors.black,),
                      title: Text("Codice di sblocco: "),
                      subtitle: Text(_bike.unlockCode.toString()),
                    ),
                  ),
                ),
              ),

              //Bike State Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: (){
                    if(_bike.bikeState == 'Prenotata' || _bike.bikeState == 'Noleggiata'){
                      new AlertDialog(
                        title: Text('Non puoi modificare la Disponibilità di questa Bicicletta'),
                      );
                    }else{
                      _dispoDialog(context, _bike.bikeState);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.assignment, color: Colors.black,),
                      title: Text("Stato bicicletta: "),
                      subtitle: Text(_bike.bikeState.toString()),
                    ),
                  ),
                ),
              ),

              //Delete Bike Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.red[600],
                child: InkWell(
                  onTap: (){
                    setState(() => _request = true);

                      deleteBike(_bike.id.toString()).then((value) {
                        showErrorDialog(context, S.of(context).success,
                            S.of(context).bike_deleted);
                        setState(() => _request = false);
                      });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Cancella Bicicletta',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

            ],
          ),
      ),
      drawer: MyDrawer(user: _user),
    );
  }

}

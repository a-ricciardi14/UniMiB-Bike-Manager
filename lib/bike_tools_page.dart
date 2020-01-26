import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'model/bike.dart';
import 'model/user.dart';


//TODO: Ottimizzare _dispoDialog() x visualizzazione corretta della scelta di disponibilità.


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

  final _formKey = GlobalKey<FormState>();
  bool _request = false;

  TextEditingController _editingController = new TextEditingController();

  _unLockDialog(BuildContext context) async {
    int _unLock;
    return showDialog(
        context: context,
        builder: (context) {
          return new Form(
            key: _formKey,
            child: new AlertDialog(
              title: Text("Modifica parametro: "),
              content: new TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                controller: _editingController,
                validator: (value){
                  if(value.isEmpty){
                    return S.of(context).pass_wrong;
                  }else{
                    _unLock = int.parse(value);
                  }
                },
              ),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5.0,
                    textColor: Colors.red[600],
                    child: _request ? CircularProgressIndicator()
                        : Text("Salva"),
                    onPressed: _request ? null : () {
                      if (_formKey.currentState.validate()) {
                        setState(() => _request = true);
                        setBikeUnCode(_unLock, _bike).then((value){
                          showErrorDialog(context, S.of(context).success,
                              'Parametro modificato!');
                          setState(() => _request = false);
                        }).catchError((e) {
                          showErrorDialog(context, 'Ops!',
                              S.of(context).service_exception);
                          setState(() => _request = false);
                        });
                      }
                    }
                )
              ],
            ),
          );
        }
        );
  }

  _dispoDialog(BuildContext context) async {
    String _selectedDisp;
    int _disp;
    List<String> _listDisp = ['Disponibile', 'Smarrita', 'Manutenzione'];

    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text("Modifica disponibilità: "),
            content: new DropdownButton(
              isExpanded: true,
              value: _selectedDisp,
              items: _listDisp.map((value){
                return new DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        new Icon(Icons.description),
                        new SizedBox(width: 10.0,),
                        new Text(value),
                      ],
                    ),
                  value: value,
                );
              }).toList(),
              hint: new Text("Seleziona disponibilità"),
              onChanged: (newVal){
                setState(() {
                  _selectedDisp = newVal;
                  if(_selectedDisp == 'Disponibile'){
                    _disp = 1;
                  }else if(_selectedDisp == 'Smarrita'){
                    _disp = 4;
                  }else if(_selectedDisp == 'Manutenzione'){
                    _disp = 5;
                  }
                });
                },
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  textColor: Colors.red[600],
                  child: Text("Salva"),
                  onPressed: _request ? null : () {
                    if (_selectedDisp != null) {
                      setState(() => _request = true);
                      setBikeDisp(_disp, _bike).then((value){
                        showErrorDialog(context, S.of(context).success,
                            'Parametro modificato!');
                        setState(() => _request = false);
                      }).catchError((e) {
                        showErrorDialog(context, 'Ops!',
                            S.of(context).service_exception);
                        setState(() => _request = false);
                      });
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
                    _unLockDialog(context);
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
                      return showDialog(
                        context: context,
                        builder: (context){
                          return new AlertDialog(
                            title: Text('Non puoi modificare la Disponibilità di questa Bicicletta'),
                          );
                        },
                      );
                    }else{
                      _dispoDialog(context);
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
                    if(_bike.bikeState == "Disponibile" || _bike.bikeState == "Manutenzione") {
                      setState(() => _request = true);
                      deleteBike(_bike.id.toString()).then((value) {
                        showErrorDialog(context, S.of(context).success,
                            S.of(context).bike_deleted);
                        setState(() => _request = false);
                      });
                    }else{
                      showErrorDialog(context, S.of(context).bike_not_avaiable, "Non puoi scegliere questa bicicletta");
                      setState(() => _request = false);
                    }
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

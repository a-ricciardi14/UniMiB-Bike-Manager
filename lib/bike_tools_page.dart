import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/drawer.dart';

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

  TextEditingController _locationController = new TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Modifica parametro: "),
            content: new TextField(
              controller: _locationController,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                textColor: Colors.red[600],
                child: Text("Submit"),
                onPressed: (){},
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
                child: InkWell(
                  onTap: (){
                    _displayDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.apps, color: Colors.black,),
                      title: Text("Codice rastrelliera: "),
                      subtitle: Text(_bike.rack.id.toString()),
                    ),
                  ),
                ),
              ),

              //Bike UnlockCode Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: (){
                    _displayDialog(context);
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
                    _displayDialog(context);
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

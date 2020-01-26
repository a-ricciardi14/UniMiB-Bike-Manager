import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'package:unimib_bike_manager/model/bike.dart';
import 'package:unimib_bike_manager/model/bike_list.dart';
import 'package:unimib_bike_manager/model/rack.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:geolocator/geolocator.dart';


//TODO: Card Position Rack --> Aggiungere onTap() la funzione _showDialog() per la modifica del parametro come mostrare una input text come googleMaps per la posizione. (SERVE KEY GOOGLE MAPS)
//TODO: Ottimizzare _showRackBikes(), ridimensionamento dell'AllertDialog().

class RackToolsPage extends StatefulWidget {
  final User user;
  final Rack rack;

  RackToolsPage({Key key, @required this.user, @required this.rack}) : super(key: key);

  @override
  _RackToolsPageState createState() => _RackToolsPageState();
}

class _RackToolsPageState extends State<RackToolsPage> {
  User get _user => widget.user;
  Rack get _rack => widget.rack;

  TextEditingController _editingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _request = false;

  Future<BikeList> _bikeList;

  _displayDialog(BuildContext context, var key) async {
    _editingController.text = '';
    int _newCapacity;
    String _localDesc = '';

    return showDialog(
      context: context,
      builder: (context) {
        if(key is String){
          return Form(
            key: _formKey,
            child: new AlertDialog(
              title: Text("Modifica parametro: "),
              content: new TextFormField(
                controller: _editingController,
                validator: (value){
                  if(value.isEmpty){
                    S.of(context).desc_empty;
                  }else{
                    _localDesc = value;
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
                      setRacksParameters(_localDesc, _rack).then((value) {
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
        }else if(key is int){
          return Form(
            key: _formKey,
            child: new AlertDialog(
              title: Text("Modifica parametro: "),
              content: new TextFormField(
                keyboardType: TextInputType.number,
                controller: _editingController,
                validator: (value){
                  if(value.isEmpty){
                    return S.of(context).desc_empty;
                  }else{
                    if(int.parse(_editingController.text) < key){
                      return S.of(context).wrong;
                    }else{
                      _newCapacity = int.parse(_editingController.text);
                    }
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
                        setRacksParameters(_newCapacity, _rack).then((value) {
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
      }
      );
  }

  _showRackBikes(BuildContext context, Rack _tempRack){
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text("Lista biciclette della rastrelliera: "),
            content: new FutureBuilder(
              future: _bikeList,
              builder: (context, bikeSnap){
                if(bikeSnap.hasData){
                  return new ListView.builder(
                      itemCount: bikeSnap.data.bikes == null
                          ? 0
                          : bikeSnap.data.bikes.length,
                      itemBuilder: (context, index){
                        Bike _tempBike = bikeSnap.data.bikes[index];
                        return new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _tempBike.rack.id == _tempRack.id ?
                            new Row(
                              children: <Widget>[
                                new Icon(Icons.directions_bike, size: 30.0, color: Colors.green[600],),
                                new SizedBox(width: 20.0,),
                                new Text(
                                  'Bicicletta id: ',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                  ),
                                ),
                                new Text(
                                  _tempBike.id.toString(),
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ) : new Container(height: 0.0,),
                          ],
                        );
                      });
                }else if(bikeSnap.hasError){
                  throw Exception('Failed to build BikeList');
                }
              },
            ),
          );
        }
    );
  }

  GoogleMapController mapController;
  //Future<Position> currentLocation;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

//  //funzione uguale a quella presente in map
//  Future<Position> fetchLocation() async {
//    return Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//  }

  Set<Marker> initMarker(BuildContext context, Rack rack){
    Set<Marker> set = Set<Marker>();
    Marker marker;

    marker = Marker(
      markerId: MarkerId(_rack.id.toString()),
      position: LatLng(_rack.latitude, _rack.longitude),
      draggable: false,
      infoWindow: InfoWindow(
        title: _rack.locationDescription,
        snippet: _rack.addressLocality,
      ),
    );
    set.add(marker);
    return set;
  }

  @override
  void initState() {
    _request = false;
    _bikeList = fetchBikeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Rastrelliera ' +
            _rack.id.toString()
        ),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      backgroundColor: Colors.grey[300],

      body: Container(
        child: RefreshIndicator(
          child: ListView(
            children: <Widget>[

              //Rack Name Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: (){
                    _displayDialog(context, _rack.locationDescription);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.home),
                        SizedBox(width: 40.0),
                        Text(_rack.locationDescription),
                      ],
                    ),
                  ),
                ),
              ),

              //Rack Position Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(width: 40.0),
                      Text(
                          _rack.streetAddress +
                              ' (' +
                              _rack.addressLocality +
                              ')',
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),

              //Rack Capacity Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: (){
                    _displayDialog(context, _rack.capacity);
                    _onRefresh();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.apps),
                        SizedBox(width: 40.0),
                        Text('Stand Totali:' + _rack.capacity.toString(),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              ),

              //Rack Bike_Available Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: (){
                    _showRackBikes(context, _rack);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.directions_bike),
                        SizedBox(width: 40.0),
                        Text('Biciclette Disponibili: ' + _rack.availableBikes.toString(),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              ),

              //Delete Rack Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                color: Colors.red[600],
                child: InkWell(
                  onTap: (){
                    setState(() => _request = true);

                    deleteRack(_rack.id.toString()).then((value) {
                      showErrorDialog(context, S.of(context).success,
                          S.of(context).rack_removed);
                      setState(() => _request = false);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Cancella Rastrelliera',
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

              //Google Maps Card
              Card(
                margin: EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Container(
                      width: 300.0,
                      height: 250.0,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(_rack.latitude, _rack.longitude),
                            zoom: 16.0
                        ),
                        onMapCreated: (controller){
                          mapController = controller;
                        },
                        myLocationEnabled: false,
                        markers: initMarker(context, _rack),
                      )
                  ),
                ),
              ),
            ],
          ),

          onRefresh: () {
            return _onRefresh();
          },
        ),
      ),
      drawer: MyDrawer(user: _user),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      //currentLocation = fetchLocation();
    });
  }
}

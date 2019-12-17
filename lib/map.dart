import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';

import 'package:unimib_bike_manager/functions/functions.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/model/rack_list.dart';
import 'package:unimib_bike_manager/model/rack.dart';

//questa struttura mi serve per poter richiedere e quindi aspettare
//contemporaneamente due risorse in modo che l'interfaccia venga
//costruita quando entrambe sono disponibili
class Merged {
  final RackList list;
  final Position pos;

  Merged({@required this.list, @required this.pos});
}

class MapPage extends StatefulWidget {
  final User user;

  MapPage({Key key, @required this.user}) : super(key: key);

  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage> with TickerProviderStateMixin {
  User get _user => widget.user;
  set _renting(value) {
    widget.user.renting = value;
  }

  GoogleMapController mapController;

  Future<Position> currentLocation;
  Future<RackList> rackList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _rotationController;
  bool _loading = false;

  //funzione che ottiene la posizione corrente
  Future<Position> fetchLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    rackList = fetchRackList();
    currentLocation = fetchLocation();

    _rotationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    _rotationController.addListener(() {
      setState(() {
        if (_rotationController.status == AnimationStatus.completed) {
          if (_loading == true) {
            _rotationController.repeat();
          } else {
            _rotationController.reset();
          }
        }
      });
    });
    super.initState();
  }

  //funzione che costruisce i marker in base alle rastrelliere
  Set<Marker> initMarker(
      BuildContext context, List<Rack> racks, Position current) {
    Set<Marker> set = Set<Marker>();
    Marker marker;

    Future<double> distance;

    for (int i = 0; i < racks.length; i++) {
      distance = Geolocator().distanceBetween(current.latitude,
          current.longitude, racks[i].latitude, racks[i].longitude);

      marker = Marker(
          markerId: MarkerId(racks[i].id.toString()),
          position: LatLng(racks[i].latitude, racks[i].longitude),
          draggable: false,
          infoWindow: InfoWindow(
            title: racks[i].locationDescription,
            snippet: racks[i].addressLocality,
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                          title: Text(
                        racks[i].locationDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20.0),
                      )),
                      Divider(),
                      _createTile(
                          context, Icons.location_on, racks[i].streetAddress),
                      FutureBuilder<double>(
                        future: distance,
                        builder: (context, distSnap) {
                          if (distSnap.hasData) {
                            return _createTile(
                                context,
                                Icons.directions,
                                (distSnap.data / 1000).round().toString() +
                                    ' km');
                          } else {
                            return _createTile(
                                context, Icons.directions, '...');
                          }
                        },
                      ),
                      _createTile(context, Icons.directions_bike,
                          racks[i].availableBikes.toString()),
                      FlatButton(
                        child: Text(S.of(context).go,
                            style: TextStyle(color: Colors.red[800])),
                        onPressed: () =>
                            launchURL(racks[i].latitude, racks[i].longitude),
                      ),
                    ],
                  );
                });
          });

      set.add(marker);
    }

    return set;
  }

  //funzione che costruisce una listTile
  ListTile _createTile(BuildContext context, IconData icon, String string) {
    return ListTile(
      leading: Icon(icon, color: Colors.red[800],),
      title: Text(string),
    );
  }

  //funzione che calcola la distanza
  launchURL(double destLat, double destLong) async {
    String url = 'https://www.google.com/maps/dir/?api=1&origin=';

    Position current = await Geolocator().getCurrentPosition();

    url += current.latitude.toString() +
        ',' +
        current.longitude.toString() +
        '&destination=' +
        destLat.toString() +
        ',' +
        destLong.toString() +
        '&travelmode=walking';

    print(url);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //funzione che costruisce il bottom sheet che notifica il noleggio in corso
  _showStartedRentBottomSheet() {
    //Se non li metto espliciti (inizio e code) in Text prova ugualmente
    // a chiamare il metodo
    //anche se l'oggetto renting non esiste, lanciando un'eccezione

    String inizio = _user.renting != null ? _user.renting.getStartHour() : '';

    String code =
        _user.renting != null ? _user.renting.bike.unlockCode.toString() : '';

    _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        //Larghezza schermo
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10.0, left: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.warning,
                      size: 35.0,
                      color: Color(0xFFFF4081),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/report'),
                  ),
                  Text(
                    'Segnala',
                    style: TextStyle(color: Color(0xFFFF4081)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Noleggio in corso',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 23.0, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Ora di inizio: $inizio',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Codice di sblocco: ',
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        Text(
                          '$code',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.lock_outline,
                      size: 35.0,
                      color: Color(0xFFFF4081),
                    ),
                    onPressed: () {
                      showEndRentDialog(context, _user.renting);
                    },
                  ),
                  Text(
                    'Blocca',
                    style: TextStyle(color: Color(0xFFFF4081)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  //funzione che costruisce l'alert dialog per la conferma del noleggio
  /*Future<void> _startRentDialog() {

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Riepilogo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.directions_bike),
                          Text('Codice bicicletta'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Text('Indirizzo'),
                        ],
                      ),
                      Text('Indirizzo'),
                      Text('Città'),
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Conferma'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _renting = true);
                  _showStartedRentBottomSheet();
                },
              ),
              FlatButton(
                child: Text('Annulla'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text('Mappa Rastrelliere'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/rack_list');
              }),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_rotationController),
            child: IconButton(
                icon: Icon(Icons.refresh),
                color: Colors.white,
                onPressed: () async {
                  _loading = true;
                  _rotationController.forward();

                  await _refresh();

                  _loading = false;
                }),
          ),
        ],
      ),
      drawer: MyDrawer(user: _user),
      body: Container(
        //uso un future builder che mi permette di costruire l'interfaccia in base
        //allo stato dei dati (errore di ricezione dal server, dati ottenuti ecc)
        child: FutureBuilder<Merged>(
          future: Future.wait([rackList, currentLocation]).then(
              (response) => new Merged(list: response[0], pos: response[1])),
          builder: (context, snapshot) {
            //se riesco a ottenere tutti i dati allora costruisco la mappa
            if (snapshot.hasData) {
              if (_user.renting != null) {
                //attende che tutta la pagina sia caricata completamente e poi chiama la funzione
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _showStartedRentBottomSheet());
              }

              return Stack(children: <Widget>[
                GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(snapshot.data.pos.latitude,
                        snapshot.data.pos.longitude),
                    zoom: 11.0,
                  ),
                  markers: initMarker(
                      context, snapshot.data.list.racks, snapshot.data.pos),
                ),

              ]);
              //se ho un errore ritorno l'errore
            } else if (snapshot.hasError) {
              return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Ops! Qualcosa è andato storto',
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Stiamo riscontrando dei problemi a contattare il servizio'),
                    ],
                  ));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      rackList = fetchRackList();
      currentLocation = fetchLocation();
    });
  }
}

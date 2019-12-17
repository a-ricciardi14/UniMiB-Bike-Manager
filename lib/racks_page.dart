import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:unimib_bike_manager/model/rack.dart';
import 'package:unimib_bike_manager/rack_tools_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';

import 'drawer.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'model/user.dart';
import 'model/rack_list.dart';

//TODO: Attivare bottone e Implementare funzione per l'aggiunta di una rastrelliera.
//TODO: Creare Pop_up o Pagina per l'aggiunta di una rastrelliera.

class RacksPage extends StatefulWidget {
  final User user;

  RacksPage({Key key, @required this.user}) : super(key: key);

  @override
  _RacksPage createState() => _RacksPage();
}

class _RacksPage extends State<RacksPage> {
  User get _user => widget.user;

  Future<RackList> rackList;
  Future<Position> currentLocation;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //funzione uguale a quella presente in map
  Future<Position> fetchLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }


  @override
  void initState() {
    rackList = fetchRackList();
    currentLocation = fetchLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text('Lista Rastrelliere'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.map),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/map');
            },
          ),
        ],
      ),
      drawer: MyDrawer(user: _user),
      body: Container(
        child: FutureBuilder<RackList>(
          future: rackList,
          builder: (context, rackSnap) {
            if (rackSnap.hasData) {
              return RefreshIndicator(
                child: Stack(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: rackSnap.data.racks == null
                          ? 0
                          : rackSnap.data.racks.length,
                      itemBuilder: (context, int index) {
                        return Card(
                          margin: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          child: InkWell(
                            onTap: (){
                              Rack _rackChosen = rackSnap.data.racks[index];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RackToolsPage(user: _user, rack: _rackChosen)));
                            },
                            child: Column(
                              //mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    title: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        rackSnap
                                            .data.racks[index].locationDescription,
                                        //style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.location_on,
                                              color: Colors.grey[600]),
                                          Expanded(
                                            child: Text(
                                                rackSnap.data.racks[index]
                                                        .streetAddress +
                                                    ' (' +
                                                    rackSnap.data.racks[index]
                                                        .addressLocality +
                                                    ' )',
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Opacity(
                        opacity: _user.mEmail != 'guest'
                            ? (_user.renting != null ? 0.0 : 1.0)
                            : 0.0,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            backgroundColor: Colors.red[600],
                            child: Icon(Icons.add,),
                            onPressed: null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onRefresh: () {
                  return _onRefresh();
                },
              );
            } else if (rackSnap.hasError) {
              return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        S.of(context).ops_wrong,
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(S.of(context).service_exception),
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

  Future<void> _onRefresh() async {
    setState(() {
      rackList = fetchRackList();
      currentLocation = fetchLocation();
    });
  }

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

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double result;

    Geolocator().distanceBetween(lat1, lon1, lat2, lon2).then((distance) {
      result = distance;
    });

    return result;
  }
}

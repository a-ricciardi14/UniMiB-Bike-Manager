import 'package:flutter/material.dart';
import 'dart:async';
import 'package:unimib_bike_manager/model/bike_list.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'package:unimib_bike_manager/drawer.dart';

import 'package:unimib_bike_manager/model/bike.dart';
import 'package:unimib_bike_manager/bike_tools_page.dart';

import 'model/rack.dart';

class BikesPage extends StatefulWidget {

  final User user;

  BikesPage({Key key, @required this.user}) : super(key: key);

  @override
  _BikesPageState createState() => _BikesPageState();
}

class _BikesPageState extends State<BikesPage> {
  User get _user => widget.user;

  Rack _rack;
  Future<BikeList> bikeList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bikeList = fetchBikeList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text('Lista Biciclette'),
      ),
      drawer: MyDrawer(user: _user),
      body: Container(
        child: FutureBuilder<BikeList>(
          future: bikeList,
          builder: (context, bikeSnap) {
            if (bikeSnap.hasData) {
              return RefreshIndicator(
                child: Stack(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: bikeSnap.data.bikes == null
                          ? 0
                          : bikeSnap.data.bikes.length,
                      itemBuilder: (context, int index) {
                        _rack = bikeSnap.data.bikes[index].rack;

                        return Card(
                          margin: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          child: InkWell(
                            onTap: (){
                              Bike _bikeChosen = bikeSnap.data.bikes[index];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BikeToolsPage(user: _user, bike: _bikeChosen)));
                            },
                            child: Column(
                              //mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                          title: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 2.0),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.directions_bike, color: Colors.green,),
                                                SizedBox(width: 5.0,),
                                                Text(
                                                    'Bicicletta: Id ' + bikeSnap.data.bikes[index].id.toString(),
                                                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child:
                                            Text(
                                                'Codice Sblocco: ' + bikeSnap.data.bikes[index].unlockCode.toString(),
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          trailing: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(Icons.assignment, color: Colors.grey[600],),
                                                    SizedBox(width: 5.0,),
                                                    Text(bikeSnap.data.bikes[index].bikeState, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                                SizedBox(height: 8.0,),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(Icons.apps, color: Colors.grey[600],),
                                                    SizedBox(width: 5.0,),
                                                    Text('Rastrelliera: ' + _rack.id.toString()),
                                                  ],
                                                ),
                                              ],
                                            )
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
            } else if (bikeSnap.hasError) {
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
      bikeList = fetchBikeList();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'dart:async';

import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/drawer.dart';
import 'package:unimib_bike_manager/model/rental_list.dart';
import 'package:unimib_bike_manager/functions/requests.dart';

class RentalPage extends StatefulWidget {
  final User user;

  RentalPage({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  _RentalPage createState() => _RentalPage();
}

class _RentalPage extends State<RentalPage> {
  User get _user => widget.user;

  Future<RentalList> rentalList;

  @override
  void initState() {
    rentalList = fetchRentalList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).rentals),
        ),
        drawer: MyDrawer(user: _user),
        body: Container(
            child: FutureBuilder<RentalList>(
          future: rentalList,
          builder: (context, rentalSnap) {
            if (rentalSnap.hasData) {
              return RefreshIndicator(
                  child: ListView.builder(
                    itemCount: rentalSnap.data.rentals == null
                        ? 0
                        : rentalSnap.data.rentals.length,
                    itemBuilder: (context, int index) {
                      //se l'utente sta noleggiando il noleggio in corso non viene
                      //mostrato
                      if (rentalSnap.data.rentals[index].endRack != null) {
                        return Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(Icons.date_range,
                                        color: Colors.black54),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                          rentalSnap.data.rentals[index]
                                              .getDay(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(Icons.access_time,
                                              color: Colors.black54),
                                          SizedBox(
                                            width: 3.0,
                                          ),
                                          Text(
                                              rentalSnap.data.rentals[index]
                                                  .getHours(),
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          SizedBox(
                                            width: 10.0,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.location_on,
                                        color: Colors.black54),
                                    Text(
                                      rentalSnap.data.rentals[index].startRack
                                          .locationDescription,
                                      //style: TextStyle(color: Colors.grey)
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color: Colors.black54),
                                    Text(
                                      rentalSnap.data.rentals[index].endRack
                                          .locationDescription,
                                      //style: TextStyle(color: Colors.grey)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  onRefresh: () {
                    return _onRefresh();
                  });
            } else if (rentalSnap.hasError) {
              return Text('${rentalSnap.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )));
  }

  Future<void> _onRefresh() async {
    setState(() {
      rentalList = fetchRentalList();
    });
  }
}

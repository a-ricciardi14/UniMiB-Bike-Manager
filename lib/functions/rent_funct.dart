import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';

import 'package:unimib_bike_manager/functions/requests.dart';
import 'package:unimib_bike_manager/model/rental.dart';


//Funzione per scannerizare il qrcode
Future<String> scan() async {
  try {
    String result = await BarcodeScanner.scan();

    return result;
  } on PlatformException catch (e) {
    //Errore permessi non concessi
    if (e.code == BarcodeScanner.CameraAccessDenied) {
      return 'Camera negated';
    } else {
      throw Exception('$e');
    }
    //Errore di chiusura della fotocamera prima che il codice possa essere catturato
  } on FormatException {
    return 'No read';
  } catch (e) {
    throw Exception('$e');
  }
}

//Funzione che passato l'id della bicicletta prova ad avviare il noleggio
void tryRent(String id, BuildContext context) {
  fetchBikeInfo(id).then((bike) {
    if (bike.bikeState == 'Disponibile') {
      String address =
          bike.rack.addressLocality + ' ' + bike.rack.streetAddress;

      Navigator.popAndPushNamed(context, '/confirmation',
          arguments: <String, String>{
            'bike': bike.id.toString(),
            'rack': bike.rack.locationDescription,
            'address': address,
          });
    } else {
      showErrorDialog(context, 'Ops!', S.of(context).bike_not_avaiable);
    }
  }).catchError((e) {
    showErrorDialog(context, 'Ops!', S.of(context).request_failed);
  });
}

//Funzione che prova a chiudere un noleggio in corso
void tryEndRent(String id, Rental rent, BuildContext context) {
  fetchRack(id).then((rack) {
    if (rack.availableStands > 0) {
      String address = rack.addressLocality + ' ' + rack.streetAddress;

      Navigator.popAndPushNamed(context, '/confirmation',
          arguments: <String, String>{
            'bike': rent.bike.id.toString(),
            'rack': rack.locationDescription,
            'address': address,
            'rent': rent.id.toString(),
            'id': rack.id.toString(),
          });
    } else {
      showErrorDialog(context, 'Ops!', S.of(context).rack_not_avaiable);
    }
  }).catchError((e) {
    showErrorDialog(context, 'Ops!', S.of(context).request_failed);
  });
}

//funzione che costruisce il bottom sheet per iniziare il noleggio
//(per ora non è più utilizzata)
/*void showRentBottomSheet(
    GlobalKey<ScaffoldState> scaffold, BuildContext context) {


  final controller = TextEditingController();
  String id;

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Padding(
            padding: EdgeInsets.only(
                //larghezza schermo
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: S.of(context).bikeCode,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                    ),
                  ],
                ),
                FlatButton(
                  child: Text('Conferma'),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      Navigator.pop(context);
                      scaffold.currentState.showSnackBar(SnackBar(
                        content: Text('Codice bicicletta non valido'),
                        duration: Duration(seconds: 4),
                        action: SnackBarAction(
                            label: 'Ok',
                            onPressed: () {
                              scaffold.currentState.hideCurrentSnackBar();
                            }),
                      ));
                    } else {
                      id = controller.text;

                      controller.clear();

                      fetchBikeInfo(id).then((bike) {
                        if (bike.bikeState == 'Disponibile') {
                          String address = bike.rack.addressLocality +
                              ' ' +
                              bike.rack.streetAddress;

                          Navigator.popAndPushNamed(context, '/confirmation',
                              arguments: <String, String>{
                                'id': bike.id.toString(),
                                'rack': bike.rack.locationDescription,
                                'address': address,
                              });
                        } else {
                          showErrorDialog(
                              context, 'Ops!', 'Bicicletta non disponibile');
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      });
}*/

void showRentDialog(BuildContext context) {

  final controller = TextEditingController();
  String id;

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          //title: Text(S.of(context).rent),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: S.of(context).bikeCode,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    scan().then((value) {
                      if (value != 'Camera negated' && value != 'No read') {
                        tryRent(value, context);
                      } else {
                        showErrorDialog(context, 'Ops!', value);
                      }
                    }).catchError((e) {
                      showErrorDialog(context, 'Ops!', S.of(context).wrong);
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(color: Color(0xFFFF4081)),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text(
                    S.of(context).confirm,
                    style: TextStyle(color: Color(0xFFFF4081)),
                  ),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      showErrorDialog(context, 'Ops!', S.of(context).id_empty);
                    } else {
                      id = controller.text;

                      controller.clear();

                      tryRent(id, context);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      });
}

//funzione che mostra il dialog per terminare il noleggio
void showEndRentDialog(BuildContext context, Rental rent) {

  final controller = TextEditingController();
  String id;

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          //title: Text(S.of(context).rent_end),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: S.of(context).rack_code,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    scan().then((value) {
                      print(value);

                      if (value != 'Camera negated' && value != 'No read') {
                        tryEndRent(value, rent, context);
                      } else {
                        showErrorDialog(context, 'Ops!', value);
                      }
                    }).catchError((e) {
                      showErrorDialog(context, 'Ops!', S.of(context).wrong);
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(color: Color(0xFFFF4081)),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text(
                    S.of(context).confirm,
                    style: TextStyle(color: Color(0xFFFF4081)),
                  ),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      showErrorDialog(context, 'Ops!', S.of(context).id_empty);
                    } else {
                      id = controller.text;

                      controller.clear();

                      tryEndRent(id, rent, context);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      });
}

//Funzione che mostra un dialog di errore
Future<void> showErrorDialog(
    BuildContext context, String title, String subtitle) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      });
}

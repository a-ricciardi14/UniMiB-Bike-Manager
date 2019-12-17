import 'package:flutter/material.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';

import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/functions/rent_funct.dart';
import 'package:unimib_bike_manager/functions/requests.dart';

class ConfirmationPage extends StatefulWidget {
  final User user;

  ConfirmationPage({Key key, @required this.user}) : super(key: key);

  @override
  _ConfirmationPage createState() => _ConfirmationPage();
}

class _ConfirmationPage extends State<ConfirmationPage> {
  //User get _user => widget.user;
  set _renting(value) {
    widget.user.renting = value;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    final List list = args.values.toList();
    bool _endRent = false;

    //controlla se deve visualizzare la conferma per la fine del noleggio
    //o per l'inizio di un noleggio
    if (args.containsKey('rent')) {
      _endRent = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).rent_gen),
      ),
      body: Container(
        //child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                _endRent ? S.of(context).rent_end : S.of(context).rent_confirm,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.directions_bike),
                      title: Text(list[0]),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(list[1]),
                      subtitle: Text(list[2]),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(S.of(context).cancel,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    RaisedButton(
                      child: Text(S.of(context).confirm,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        //se sta iniziando un noleggio
                        if (_endRent == false) {
                          postStartRent(list[0]).then((rental) {
                            setState(() => _renting = rental);
                            //Navigator.pop(context);

                            //torno alla pagina principale eliminando le strade
                            //precedenti
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          });
                        } else {
                          //se lo sta concludendo
                          putEndRent(list[3], list[4]).then((value) {
                            setState(() => _renting = null);
                            //Navigator.pop(context);
                            //Navigator.pushReplacementNamed(context,'/map');

                            //torno alla pagina principale eliminando le strade
                            //precedenti
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          }).catchError((e) {
                            showErrorDialog(
                                context, 'Ops!', S.of(context).rent_end_failed);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'package:unimib_bike_manager/model/user.dart';
import 'package:unimib_bike_manager/authentication/authentication_bloc.dart';
import 'package:unimib_bike_manager/authentication/authentication_event.dart';

//TODO: Ottimizzare chiusura automatica ExpansionTile.


class MyDrawer extends StatelessWidget {

  final User user;

  MyDrawer({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Drawer(
      child: ListView(padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: null,
              accountEmail: Text(user.mEmail),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.adb, color: Colors.black, ),
                backgroundColor: Colors.grey[600],
              ),
              decoration: BoxDecoration(
                color: Colors.red[600],
              ),
            ),

            //Drawer --> HomePage()
            ListTile(
              leading: Icon(Icons.home, color: Colors.black,),
              title: Text('Home Page'),
              onTap: () {
                Navigator.pushNamed(context,'/home_page');
              },
            ),

            //Drawer --> BikesManagement
            ExpansionTile(
              leading: Icon(Icons.directions_bike, color: Colors.black),
              backgroundColor: Colors.grey[200],
              title: Text(
                'Gestione Biciclette',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey[800],),
                  title: Text('Gestisci Bicicletta'),
                  onTap: () {
                    Navigator.pushNamed(context,'/bike_list');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add_circle_outline, color: Colors.green,),
                  title: Text('Aggiungi Bicicletta'),
                  onTap: () {
                    Navigator.pushNamed(context,'/bike_add');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.remove_circle_outline, color: Colors.red[800],),
                  title: Text('Rimuovi Bicicletta'),
                  onTap: () {
                    Navigator.pushNamed(context,'/bike_remove');
                  },
                ),
              ],
            ),

            //Drawer --> RacksManagement
            ExpansionTile(
              leading: Icon(Icons.apps, color: Colors.black),
              backgroundColor: Colors.grey[200],
              title: Text(
                'Gestione Rastrelliere',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey[800],),
                  title: Text('Gestisci Rastrelliera'),
                  onTap: () {
                    Navigator.pushNamed(context,'/rack_list');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add_circle_outline, color: Colors.green,),
                  title: Text('Aggiungi Rastrelliera'),
                  onTap: () {
                    Navigator.pushNamed(context,'/rack_add');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.remove_circle_outline, color: Colors.red[800],),
                  title: Text('Rimuovi Rastrellioera'),
                  onTap: () {
                    Navigator.pushNamed(context,'/rack_remove');
                  },
                ),
              ],
            ),

            //Drawer --> ReportsManagement
            ExpansionTile(
              leading: Icon(Icons.report_problem, color: Colors.black),
              backgroundColor: Colors.grey[200],
              title: Text(
                'Gestione Segnalazioni',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.list, color: Colors.grey[800],),
                  title: Text('Lista Segnalazioni'),
                  onTap: () {
                    Navigator.pushNamed(context,'/report_page');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.report_problem, color: Colors.red[800],),
                  title: Text('Segnala Rastrelliera'),
                  onTap: () {
                    Navigator.pushNamed(context, '/racks_report');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.report_problem, color: Colors.red[800],),
                  title: Text('Segnala Bicicletta'),
                  onTap: () {
                    Navigator.pushNamed(context,'/bikes_report');
                  },
                ),
              ],
            ),

            //Drawer --> LogOut
            ListTile(
               leading: Icon(Icons.power_settings_new, color: Colors.red[900],),
               title: Text(S.of(context).logout),
               onTap: () {
                 //Chiudo il drawer per evitare errori
                 //print('pop fatto');
                  authenticationBloc.dispatch(LoggedOut());
                 Navigator.popUntil(context, ModalRoute.withName('/'));
               },
             ),
           ]
      ),
    );
  }
}

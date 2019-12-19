import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';

import 'package:unimib_bike_manager/model/user.dart';

import 'package:unimib_bike_manager/authentication/authentication_bloc.dart';
import 'package:unimib_bike_manager/authentication/authentication_event.dart';


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

            ListTile(
              leading: Icon(Icons.directions_bike, color: Colors.black,),
              title: Text('Lista Biciclette'),
              onTap: () {
                Navigator.pushNamed(context,'/bike_list');
              },
            ),

            ListTile(
              leading: Icon(Icons.apps, color: Colors.black,),
              title: Text('Lista Rastrielliere'),
              onTap: () {
                Navigator.pushNamed(context,'/rack_list');
              },
            ),

            ListTile(
              leading: Icon(Icons.warning, color: Colors.black,),
              title: Text('Lista Segnalazioni'),
              onTap: () {
                Navigator.pushNamed(context,'');
              },
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

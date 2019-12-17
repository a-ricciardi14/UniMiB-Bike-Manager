import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unimib_bike_manager/add_bike_page.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:unimib_bike_manager/home_page.dart';
import 'package:unimib_bike_manager/racks_report_page.dart';
import 'package:unimib_bike_manager/remove_bike_page.dart';
import 'package:unimib_bike_manager/add_rack_page.dart';
import 'package:unimib_bike_manager/remove_rack_page.dart';

import 'bikes_page.dart';
import 'login.dart';
import 'splash_page.dart';
import 'map.dart';
import 'bikes_report_page.dart';
import 'racks_page.dart';
import 'confirmation_page.dart';

import 'package:unimib_bike_manager/authentication/authentication_bloc.dart';
import 'package:unimib_bike_manager/authentication/authentication_event.dart';
import 'package:unimib_bike_manager/authentication/authentication_state.dart';
import 'package:unimib_bike_manager/model/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(user: User.create()));
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    //Posso dirgli cosa fare quando passa da uno stato all'altro
    //print(transition.toString());
  }
}

class MyApp extends StatefulWidget {
  final User user;

  MyApp({Key key, @required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationBloc authenticationBloc;
  User get user => widget.user;
  set _email(value){
    widget.user.mEmail;
  }
  set _state(value){
    widget.user.mState;
  }
  /*set _renting(value) {
    widget.user.renting = value;
  }*/

  PermissionStatus _status;

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc(user: user);

    //evento iniziale app avviata
    authenticationBloc.dispatch(AppStarted());

    super.initState();

    //controllo permesso geolocalizzazione
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);

    if (_status != PermissionStatus.unknown) {
      PermissionHandler().requestPermissions(
          [PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
    }
  }

  @override
  void dispose() {
    print('dispose authentication');
    authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //BlocProvider fornisce il blocco al child specificato in modo che sia
    //sempre accessibile. In questo caso il nostro blocco sarà accessibile
    //in qualsiasi punto dell'app perchè il child è material App
    return BlocProvider<AuthenticationBloc>(
        bloc: authenticationBloc,
        child: MaterialApp(
          title: 'UniMib Bike',
          theme: ThemeData(
              accentColor: Colors.black,
              primaryColor: Color(0xFF3F51B5),
              primaryColorDark: Color(0xFF303F9F),
              buttonColor: Color(0xFFFF4081),
              cursorColor: Color(0xFFFF4081),
              inputDecorationTheme: InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 2.0)),
                labelStyle: TextStyle(color: Colors.black54),
              )),
          routes: {
            '/map': (context) => MapPage(user: user),
            '/home_page': (context) => HomePage(user: user),
            '/racks_report': (context) => RacksReportPage(user: user),
            '/bikes_report': (context) => BikesReportPage(user: user),
            '/rack_list': (context) => RacksPage(user: user),
            '/bike_list': (context) => BikesPage(user: user),
            '/confirmation': (context) => ConfirmationPage(user: user),
            '/bike_add': (context) => AddBike(user: user),
            '/bike_remove': (context) => RemoveBike(user: user),
            '/rack_add': (context) => AddRack(user: user),
            '/rack_remove': (context) => RemoveRack(user: user),

          },
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,

          //costruttore: in base al blocco e ai suoi stati la pagina viene costruita
          home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
            bloc: authenticationBloc,
            builder: (BuildContext context, AuthenticationState state) {
              //utente non ancora inizializzato
              if (state is AuthenticationUninitialized) {
                return SplashPage();
              }
              //utente autenticato
              if (state is AuthenticationAuthenticated) {
                return HomePage(user: user);
              }
              //schermata di caricamento
              if (state is AuthenticationLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              //utente autenticato
              if (state is AuthenticationUnauthenticated) {
                //login page contiene il loginBloc che sfrutta l'authentication bloc
                return LoginPage(user: user);
              }
            },
          ),
        ));
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.locationWhenInUse];

    if (status != PermissionStatus.granted) {
      PermissionHandler().openAppSettings();
    } else {
      _updateStatus(status);
    }
  }
}

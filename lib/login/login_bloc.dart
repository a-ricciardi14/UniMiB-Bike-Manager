import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_event.dart';
import 'login_state.dart';

import 'package:unimib_bike_manager/model/user.dart';

import 'package:unimib_bike_manager/authentication/authentication_bloc.dart';
import 'package:unimib_bike_manager/authentication/authentication_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final User user;
  //login bloc deve poter dialogare con un authentication bloc in modo da poter funzionare
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.user,
    @required this.authenticationBloc,
  })  : assert(user != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
      LoginState currentState, LoginEvent event) async* {
    if (event is LoginButtonPressed) {

      yield LoginLoading();

      try {
        final token = await user.authenticate(
            email: event.email, password: event.password);

        if (token == 'notFound') {

          yield LoginFailure(error: 'Credenziali non valide');

        } else {

          if(event.remember){
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setString('email', user.mEmail);
          }

          authenticationBloc.dispatch(LoggedIn(token: token));
          yield LoginInitial();
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}

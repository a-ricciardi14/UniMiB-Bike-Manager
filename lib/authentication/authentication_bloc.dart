import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'authentication_state.dart';
import 'authentication_event.dart';
import 'package:unimib_bike_manager/model/user.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final User user;

  AuthenticationBloc({@required this.user}) : assert(user != null);

  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationState currentState,
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await user.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {


      yield AuthenticationLoading();

      await user.persistToken(event.token);

      yield AuthenticationAuthenticated();

    }

    if(event is LoggedOut) {

      yield AuthenticationLoading();

      await user.deleteToken();

      yield AuthenticationUnauthenticated();

    }
  }
}

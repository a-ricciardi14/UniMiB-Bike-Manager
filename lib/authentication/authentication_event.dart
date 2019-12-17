import 'package:flutter/foundation.dart';

abstract class AuthenticationEvent{}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;

  LoggedIn({@required this.token}): super();
}

class LoggedOut extends AuthenticationEvent {}
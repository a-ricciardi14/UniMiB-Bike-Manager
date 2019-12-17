import 'package:flutter/foundation.dart';

abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final bool remember;

  LoginButtonPressed({
    @required this.email,
    @required this.password,
    @required this.remember,
  }) : super();
}

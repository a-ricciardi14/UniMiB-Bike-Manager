import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unimib_bike_manager/model/rental.dart';

class User {
  String _mEmail;
  String _mState;
  Rental _renting;

  User(this._mEmail, this._mState,this._renting);

  User.create();

  get mEmail => _mEmail;

  get mState => _mState;

  get renting => _renting;

  set renting(value){
    if(_mEmail != 'guest') _renting = value;
  }

  set mEmail(value){
    _mEmail = value;
  }

  set mState(value){
    _mState = value;
  }

  Future<String> authenticate({
    @required String email,
    @required String password,
  }) async {
    // delay per simulare la richiesta al server
    await Future.delayed(Duration(seconds: 1));

    if (email == 'foo@example' && password == 'password') {
      _mEmail = email;
      _mState = 'active';
      //renting indica il noleggio in corso da parte dell'utente
      //se l'utente non sta noleggiando allora il contenuto sarà null
      _renting = null;

      return email;
    } else {
      return 'notFound';
    }
  }

  Future<void> deleteToken() async {
    await Future.delayed(Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.remove('email') != null){
      prefs.remove('email');
    }

    _mEmail = '';
    _mState = '';
    _renting = null;
  }

  Future<void> persistToken(String token) async {
    //area dove controllo se il token è ancora valido
    await Future.delayed(Duration(seconds: 1));
  }

  Future<bool> hasToken() async {
    //solitamente usato all'avvio nel caso in cui si sia già loggato
    await Future.delayed(Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    mEmail = (prefs.getString('email') ?? '');

    if(mEmail != ''){
      mState ='active';

      return true;
    } else{
      return false;
    }
  }
}



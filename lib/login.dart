import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimib_bike_manager/generated/i18n.dart';
import 'login/login_event.dart';
import 'login/login_state.dart';
import 'login/login_bloc.dart';
import 'model/user.dart';
import 'package:unimib_bike_manager/authentication/authentication_bloc.dart';


class LoginPage extends StatefulWidget {
  final User user;

  LoginPage({Key key, @required this.user}): assert(user != null), super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  final _formKey = GlobalKey<FormState>();

  LoginBloc loginBloc;
  //AuthenticationBloc _authenticationBloc;

  bool _obscureText = true;
  bool _rememberMe = false;
  String _email;
  String _password;

  User get _user => widget.user;

  @override
  void initState() {
    loginBloc = LoginBloc(
      user: _user,
      //gli passo l'autthentication bloc che deve usare, in questo caso
      //ricevo l'authentication bloc del contesto in cui mi trovo (Material App)
      //che non è altro che l' authentication bloc della pagina main
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    );

    super.initState();
  }

  @override
  void dispose() {
    loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: TextTheme(
            subhead: TextStyle(color: Colors.white),
          ),
          primaryColor: Colors.white,
          cursorColor: Colors.blue,
          accentColor: Colors.blue,
          hintColor: Colors.white,
          scaffoldBackgroundColor: Colors.grey[600],
          buttonColor: Colors.red[600],
          errorColor: Colors.redAccent,
          //accentColor: Color(0xFFFF4081),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red[600])),
            labelStyle: TextStyle(color: Colors.white),
          )),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 10.0),
          //la pagina si costruisce in base allo stato del login grazie
          //a BlocBuilder
          child: BlocBuilder(
              bloc: loginBloc,
              builder: (BuildContext context, LoginState state) {
                if (state is LoginFailure) {
                  //chiamo la funzione che fa la cattura e ci monto una snackbar sopra
                  _onWidgetDidBuild(() {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Credenziali non valide'),
                      duration: Duration(seconds: 5),
                    ));
                    //cambio il focus perchè la taastiera sta sopra la snackar e la copre
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                }

                return Center(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Bikes Manager',
                              style: TextStyle(fontSize: 40.0, color: Colors.white),
                            ),
                            SizedBox(height: 40.0,),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return S.of(context).emailEmpty;
                                } else {
                                  _email = value;
                                }
                                },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: (_obscureText
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                                  onPressed: _toggleObscureText,
                                ),
                              ),
                              obscureText: _obscureText,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return S.of(context).passwordEmpty;
                                } else {
                                  _password = value;
                                }
                              },
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            SwitchListTile(
                              title: Text(S.of(context).remember_me),
                              value: _rememberMe,
                              onChanged: (bool value) {
                                setState(() {
                                  _rememberMe = value;
                                });
                              },
                            ),
                            Container(
                              height: 30.0,
                            ),
                            SizedBox(
                              width: 200.0,
                              child: RaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    loginBloc.dispatch(LoginButtonPressed(
                                        email: _email, password: _password,remember: _rememberMe));
                                  }
                                },
                                child: Text(S.of(context).login,
                                    style: TextStyle(color: Colors.white,fontSize: 15.0),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                );
              }),
        ),
      ),
    );
  }

  //funzione che "cattura" la grafica dell' interfaccia corrente per permetterne la modifica
  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  //semplice funzione che oscura il testo della password
  void _toggleObscureText() {
    setState(() {
      if (_obscureText) {
        _obscureText = false;
      } else {
        _obscureText = true;
      }
    });
  }
}

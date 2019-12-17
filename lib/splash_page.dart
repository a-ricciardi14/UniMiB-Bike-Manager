import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey[600],
      ),
      child: Scaffold(
        body: Center(
          child: Text(
            'UniMiB Bike',
            style: TextStyle(fontSize: 40.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

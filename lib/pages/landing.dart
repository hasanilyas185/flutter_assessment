import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_assessment/pages/login_screen.dart';
import 'package:flutter_assessment/repositories/user_repository.dart';


class Landing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Landing_State();
  }
}

class Landing_State extends State<Landing> {
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    startTime();
    super.initState();
  }

  startTime() async {
    var duration =  const Duration(seconds: 3);
    return  Timer(duration, route);
  }

  route() {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return LoginScreen(
        userRepository: userRepository,
      );
    }));
  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 280, bottom: 16),
          child: Column(
            children: [
              Image.asset("assets/pokemon-logo.png"),
              Image.asset("assets/pokemon-text.png")
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final md = MediaQuery.of(context);
    if (md.orientation == Orientation.landscape) {
      return _widget();
    }
    return _widget();
  }
}

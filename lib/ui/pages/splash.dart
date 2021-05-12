import 'dart:async';

import 'package:chill/bloc/authentication/authentication_bloc.dart';
import 'package:chill/bloc/authentication/authentication_event.dart';
import 'package:chill/bloc/blocDelegate.dart';
import 'package:chill/repositories/userRepository.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '';
import '../constants.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    final UserRepository _userRepository = UserRepository();
    BlocSupervisor.delegate = SimpleBlocDelegate();
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 5)),
        builder: (c, s) => s.connectionState != ConnectionState.done
            ? MaterialApp(
                home: Scaffold(
                  backgroundColor: backgroundColor,
                  body: Container(
                    // width: size.width,
                    // height: size.height,
                    child: FlareActor(
                      "assets/animations/splash.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "Untitled",
                    ),
                  ),
                ),
              )
            : BlocProvider(
                create: (context) =>
                    AuthenticationBloc(userRepository: _userRepository)
                      ..add(AppStarted()),
                child: Home(userRepository: _userRepository)));
  }
}

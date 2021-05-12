import 'package:chill/ui/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // final UserRepository _userRepository = UserRepository();
  // BlocSupervisor.delegate = SimpleBlocDelegate();
  //
  // runApp(BlocProvider(
  //     create: (context) => AuthenticationBloc(userRepository: _userRepository)
  //       ..add(AppStarted()),
  //     child: Home(userRepository: _userRepository)));
  runApp(Splash());
}

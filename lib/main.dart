import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart'
;
import 'package:flutter_assessment/pages/bottom_navigation.dart';
import 'package:flutter_assessment/pages/landing.dart';
import 'package:flutter_assessment/pages/login_screen.dart';
import 'package:flutter_assessment/repositories/user_repository.dart';
import 'package:flutter_assessment/states/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication_bloc.dart';
import 'blocs/simple_bloc_observer.dart';
import 'events/authentication_event.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({required UserRepository userRepository}) : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: _userRepository,);
          }

          if (state is AuthenticationSuccess) {
            return bottomNavigation(0);
          }
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              child: Center(child: Text("Loading")),
            ),
          );
        },
      ),
    );
  }
}

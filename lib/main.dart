import 'package:flutter/material.dart';
import 'package:dhoom/pages/home_page_widget.dart';
import 'package:dhoom/pages/signup_widget.dart';
import 'package:dhoom/pages/game.dart';
import 'package:dhoom/pages/select_player_widget.dart';

void main() => runApp(Dhoom());

class Dhoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageWidget(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePageWidget(),
        '/game': (context) => DhoomGame(),
        '/signup': (context) => SignupWidget(),
        '/select_player': (context) => SelectPlayersWidget(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


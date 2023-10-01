import 'package:flutter/material.dart';
import 'package:team_formation/search_teams.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.indigoAccent.shade100,
        ),
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
      home: SearchTeams(),
    );
  }
}
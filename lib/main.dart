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
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.indigo.shade400.withOpacity(.32);
              }
              return Colors.indigo.shade400;
            },
          ),
          // activeColor: Theme.of(context).focusColor,
        ),
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
      home: SearchTeams(),
    );
  }
}

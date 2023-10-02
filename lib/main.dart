import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:team_formation/models/team_model.dart';
import 'package:team_formation/redux/actions.dart';
import 'package:team_formation/redux/app_state.dart';
import 'package:team_formation/redux/reducer.dart';
import 'package:team_formation/search_teams.dart';
import 'package:redux/redux.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Store<AppState> _store = Store<AppState>(
    appReducer,
    initialState: AppState(),
  );
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TeamModel.getFromJson('assets/heliverse_mock_data.json').then(
      (value) {
        _store.dispatch(SetTeams(value));
      },
    );
    return StoreProvider<AppState>(
      store: _store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
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
        ),
        home: SearchTeams(),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:team_formation/models/team_model.dart';
import 'package:team_formation/redux/actions.dart';
import 'package:team_formation/redux/app_state.dart';

AppState appReducer(AppState state, action) {
  if (action is SearchName) {
    return state.copyWith(
      teams: state.allTeams
          .where(
            (item) =>
                item.firstName
                    .toLowerCase()
                    .contains(action.query.toLowerCase()) |
                item.lastName
                    .toLowerCase()
                    .contains(action.query.toLowerCase()),
          )
          .toList(),
    );
  }

  if (action is SetTeams) {
    return state.copyWith(
      teams: action.teams,
      allTeams: action.teams,
    );
  }

  return state;
}

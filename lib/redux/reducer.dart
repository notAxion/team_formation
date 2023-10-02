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
      teamAdded: emptyTeamSelection(action.teams),
    );
  }

  if (action is ChangeFilterDomain) {
    final teams = teamsWithAppliedFilter(state.copyWith(
      selectedDomain: action.domain,
    ));

    return state.copyWith(
      teams: teams,
      selectedDomain: action.domain,
    );
  }
  if (action is ChangeFilterGender) {
    final teams = teamsWithAppliedFilter(state.copyWith(
      selectedGender: action.gender,
    ));

    return state.copyWith(
      teams: teams,
      selectedGender: action.gender,
    );
  }
  if (action is AddAvailableFilter) {
    final teams = teamsWithAppliedFilter(state.copyWith(
      availableFilter: action.availableFilter,
    ));

    return state.copyWith(
      teams: teams,
      availableFilter: action.availableFilter,
    );
  }

  if (action is AddToTeam) {
    return state.copyWith(
      teamAdded: state.teamAdded..update(action.id, (value) => !value),
      selectionCounter:
          (state.teamAdded[action.id] != null && state.teamAdded[action.id]!)
              ? state.selectionCounter + 1
              : state.selectionCounter - 1,
    );
  }

  return state;
}

List<TeamModel> teamsWithAppliedFilter(AppState state) {
  List<TeamModel> teams = (state.selectedDomain == Domain.none)
      ? state.allTeams
      : state.allTeams
          .where((team) => team.domain == state.selectedDomain)
          .toList();
  teams = (state.selectedGender == Gender.none)
      ? teams
      : teams.where((team) => team.gender == state.selectedGender).toList();
  teams = (state.availableFilter == false)
      ? teams
      : teams.where((team) => team.available == state.availableFilter).toList();

  return teams;
}

Map<int, bool> emptyTeamSelection(List<TeamModel> teams) {
  return Map.fromEntries(
    teams.map((t) => MapEntry(t.id, false)),
  );
}

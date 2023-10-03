import 'package:team_formation/models/team_model.dart';
import 'package:team_formation/redux/actions.dart';
import 'package:team_formation/redux/app_state.dart';

AppState appReducer(AppState state, action) {
  if (action is SetTeams) {
    return state.copyWith(
      teams: action.teams,
      allTeams: action.teams,
      teamAdded: emptyTeamSelection(action.teams),
    );
  }

  if (action is SearchQuery) {
    final teams = teamsWithAppliedFilter(state.copyWith(
      searchQuery: action.query,
    ));

    return state.copyWith(
      teams: teams,
      searchQuery: action.query,
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

  if (action is ClearTeamSelection) {
    return state.copyWith(
      teamAdded: emptyTeamSelection(state.allTeams),
      selectionCounter: 0,
    );
  }

  return state;
}

List<TeamModel> teamsWithAppliedFilter(AppState state) {
  List<TeamModel> teams = (state.searchQuery == "")
      ? state.allTeams
      : state.allTeams
          .where(
            (item) =>
                item.firstName
                    .toLowerCase()
                    .contains(state.searchQuery.toLowerCase()) |
                item.lastName
                    .toLowerCase()
                    .contains(state.searchQuery.toLowerCase()),
          )
          .toList();
  teams = (state.selectedDomain == Domain.none)
      ? teams
      : teams.where((team) => team.domain == state.selectedDomain).toList();
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

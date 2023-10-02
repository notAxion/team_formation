import 'package:team_formation/models/team_model.dart';

class AppState {
  List<TeamModel> teams, allTeams;
  Domain selectedDomain;
  Gender selectedGender;
  bool availableFilter;
  Map<int, bool> teamAdded;
  int selectionCounter;

  AppState({
    this.teams = const [],
    this.allTeams = const [],
    this.selectedDomain = Domain.none,
    this.selectedGender = Gender.none,
    this.availableFilter = false,
    this.teamAdded = const <int, bool>{},
    this.selectionCounter = 0,
  });

  AppState copyWith({
    List<TeamModel>? teams,
    List<TeamModel>? allTeams,
    Domain? selectedDomain,
    Gender? selectedGender,
    bool? availableFilter,
    Map<int, bool>? teamAdded,
    int? selectionCounter,
  }) {
    return AppState(
      teams: teams ?? this.teams,
      allTeams: allTeams ?? this.allTeams,
      selectedDomain: selectedDomain ?? this.selectedDomain,
      selectedGender: selectedGender ?? this.selectedGender,
      availableFilter: availableFilter ?? this.availableFilter,
      teamAdded: teamAdded ?? this.teamAdded,
      selectionCounter: selectionCounter ?? this.selectionCounter,
    );
  }
}

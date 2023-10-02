import 'package:team_formation/models/team_model.dart';

class AppState {
  List<TeamModel> teams, allTeams;
  Domain selectedDomain;
  Gender selectedGender;
  bool availableFilter;

  AppState({
    this.teams = const [],
    this.allTeams = const [],
    this.selectedDomain = Domain.none,
    this.selectedGender = Gender.none,
    this.availableFilter = false,
  });

  AppState copyWith({
    List<TeamModel>? teams,
    List<TeamModel>? allTeams,
    Domain? selectedDomain,
    Gender? selectedGender,
    bool? availableFilter,
  }) {
    return AppState(
      teams: teams ?? this.teams,
      allTeams: allTeams ?? this.allTeams,
      selectedDomain: selectedDomain ?? this.selectedDomain,
      selectedGender: selectedGender ?? this.selectedGender,
      availableFilter: availableFilter ?? this.availableFilter,
    );
  }
}

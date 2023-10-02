import 'package:team_formation/models/team_model.dart';

class AppState {
  List<TeamModel> teams, allTeams;

  AppState({
    this.teams = const [],
    this.allTeams = const [],
  });

  AppState copyWith({
    List<TeamModel>? teams,
    List<TeamModel>? allTeams,
  }) {
    return AppState(
      teams: teams ?? this.teams,
      allTeams: allTeams ?? this.allTeams,
    );
  }
}

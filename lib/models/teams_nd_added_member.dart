import 'package:team_formation/models/team_model.dart';

class TeamsNdAddedMembers {
  final List<TeamModel> teams;
  final Map<int, bool> teamAdded;

  TeamsNdAddedMembers(this.teams, this.teamAdded);

  List<TeamModel> addedTeams() {
    return List.from(
      teams.where(
        (team) => teamAdded[team.id]!,
      ),
    );
  }
}

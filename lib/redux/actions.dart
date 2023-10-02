import 'package:team_formation/models/team_model.dart';

class SearchName {
  final String query;

  SearchName(this.query);
}

class SetTeams {
  final List<TeamModel> teams;

  SetTeams(this.teams);
}

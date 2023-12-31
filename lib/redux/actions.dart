import 'package:team_formation/models/team_model.dart';

class SearchQuery {
  final String query;

  SearchQuery(this.query);
}

class SetTeams {
  final List<TeamModel> teams;

  SetTeams(this.teams);
}

class ChangeFilterDomain {
  Domain domain;
  ChangeFilterDomain(this.domain);
}

class ChangeFilterGender {
  Gender gender;
  ChangeFilterGender(this.gender);
}

class AddAvailableFilter {
  bool availableFilter;
  AddAvailableFilter(this.availableFilter);
}

class ApplyFilter {}

class AddToTeam {
  final int id;

  AddToTeam(this.id);
}

class ClearTeamSelection {}

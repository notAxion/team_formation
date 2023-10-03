import 'package:flutter/material.dart';
import 'package:team_formation/models/team_model.dart';
import 'package:team_formation/team_card.dart';

class TeamOverview extends StatelessWidget {
  final List<TeamModel> selectedTeams;
  const TeamOverview({super.key, required this.selectedTeams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team Overview"),
      ),
      body: _showSelectedTeam(),
    );
  }

  Widget _showSelectedTeam() {
    return ListView.builder(
      itemCount: selectedTeams.length,
      itemBuilder: (context, index) {
        return TeamCard(team: selectedTeams[index], hideAddButton: true);
      },
    );
  }
}

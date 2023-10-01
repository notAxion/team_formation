import 'package:flutter/material.dart';
import 'package:team_formation/models/team_model.dart';

class TeamOverview extends StatelessWidget {
  final List<TeamModel> selectedTeams;
  const TeamOverview({super.key, required this.selectedTeams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team Overview"),
      ),
      body: Center(child: Text("${selectedTeams.length}")),
    );
  }
}

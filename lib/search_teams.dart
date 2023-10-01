import 'package:flutter/material.dart';
import 'package:team_formation/models/team_model.dart';

class SearchTeams extends StatefulWidget {
  SearchTeams({super.key});

  @override
  State<SearchTeams> createState() => _SearchTeamsState();
}

class _SearchTeamsState extends State<SearchTeams> {
  final TextEditingController editingController = TextEditingController();
  List<TeamModel>? teams;

  @override
  void initState() {
    TeamModel.getFromJson(
      'assets/heliverse_mock_data.json',
    ).then((value) {
      setState(() {
        teams = value;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new team"),
      ),
      body: Container(
        // height: 500.0,
        child: Column(
          children: [
            _searchBar(),
            _showTeamList(),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {},
        controller: editingController,
        decoration: InputDecoration(
          labelText: "Search",
          hintText: "Search",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }

  Widget _showTeamList() {
    return Expanded(
      child: ListView.builder(
        itemCount: teams?.length ?? 0,
        itemBuilder: (context, index) {
          final TeamModel team = teams?[index] ?? TeamModel.errorModel();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("${team.id} ${team.firstName}"),
          );
        },
      ),
    );
  }
}

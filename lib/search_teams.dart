import 'package:flutter/material.dart';
import 'package:team_formation/models/team_model.dart';
import 'package:team_formation/team_overview.dart';

class SearchTeams extends StatefulWidget {
  SearchTeams({super.key});

  @override
  State<SearchTeams> createState() => _SearchTeamsState();
}

class _SearchTeamsState extends State<SearchTeams> {
  final TextEditingController editingController = TextEditingController();
  List<TeamModel>? teams;

  late List<bool> seletctedTeam;

  int selectionCounter = 0;

  @override
  void initState() {
    TeamModel.getFromJson(
      'assets/heliverse_mock_data.json',
    ).then((value) {
      setState(() {
        teams = value;
      });
      seletctedTeam = List.filled(teams?.length ?? 0, false);
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
            _showOnSelection(),
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
          return _TeamCard(index);
        },
      ),
    );
  }

  Widget _TeamCard(int index) {
    final TeamModel team = teams?[index] ?? TeamModel.errorModel();
    return ListTile(
      selectedColor: Theme.of(context).textSelectionTheme.selectionColor,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        margin: EdgeInsets.only(left: 16.0),
        padding: EdgeInsets.all(13.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Text("${team.gender.characters.first.toUpperCase()}"),
      ),
      selected: seletctedTeam[index],
      title: Text("${team.firstName} ${team.lastName}"),
      subtitle: Text(team.email),
      trailing: Checkbox(
        onChanged: (value) {
          if (value != null) {
            setState(() {
              seletctedTeam[index] = value;
            });
            if (seletctedTeam[index]) {
              setState(() {
                selectionCounter++;
              });
            } else {
              setState(() {
                selectionCounter--;
              });
            }
          }
        },
        value: seletctedTeam[index],
        activeColor: Theme.of(context).focusColor,
      ),
    );
  }

  Widget _showOnSelection() {
    if ((selectionCounter < 1)) {
      return const SizedBox.shrink();
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        // padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text("$selectionCounter selected"),
          ),
          trailing: FilledButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
            ),
            child: Icon(
              Icons.arrow_forward_ios_sharp,
              size: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    if (teams != null) {
                      final List<TeamModel> selectedTeams = List.from(
                        teams!.where(
                          (team) => seletctedTeam[teams!.indexOf(team)],
                        ),
                      );
                      return TeamOverview(
                        selectedTeams: selectedTeams,
                      );
                    } else {
                      throw "unexpected";
                    }
                  },
                ),
              );
            },
          ),
        ),
      );
    }
  }
}

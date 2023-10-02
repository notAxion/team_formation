import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:team_formation/models/team_model.dart';
import 'package:team_formation/redux/actions.dart';
import 'package:team_formation/redux/app_state.dart';
import 'package:team_formation/team_overview.dart';
import 'package:redux/redux.dart';

class SearchTeams extends StatefulWidget {
  SearchTeams({super.key});

  @override
  State<SearchTeams> createState() => _SearchTeamsState();
}

class _SearchTeamsState extends State<SearchTeams> {
  final TextEditingController editingController = TextEditingController();
  List<TeamModel>? teams;
  late final List<TeamModel> allTeams;

  Map<int, bool> teamAdded = <int, bool>{};

  int selectionCounter = 0;

  final _domainController = TextEditingController();

  final _genderController = TextEditingController();

  @override
  void initState() {
    TeamModel.getFromJson(
      'assets/heliverse_mock_data.json',
    ).then((value) {
      teams = value;
      allTeams = teams!;
      emptyTeamAdded(allTeams);
      setState(() {
        teams = teams;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
    super.initState();
  }

  /// sets all the value of the [teamAdded] value to false
  emptyTeamAdded(List<TeamModel> allTeams) {
    for (final team in allTeams) {
      teamAdded[team.id] = false;
    }
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(),
                _searchFilters(),
                Divider(),
              ],
            ),
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
        onChanged: (value) =>
            StoreProvider.of<AppState>(context).dispatch(SearchName(value)),
        controller: editingController,
        decoration: const InputDecoration(
          labelText: "Search",
          hintText: "Search",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }

  Widget _searchFilters() {
    final domainEntries = <DropdownMenuEntry<Domain>>[];
    for (final Domain domain in Domain.values) {
      domainEntries.add(
        DropdownMenuEntry(value: domain, label: domain.domainName),
      );
    }
    final genderEntries = <DropdownMenuEntry<Gender>>[];
    for (final Gender gender in Gender.values) {
      genderEntries.add(
        DropdownMenuEntry(value: gender, label: gender.sexuality),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _domainDropDown(domainEntries),
          _genderDropDown(genderEntries),
          _availableCheckBox(),
        ],
      ),
    );
  }

  Widget _domainDropDown(List<DropdownMenuEntry<Domain>> domainEntries) {
    return StoreConnector<AppState, Domain>(
      converter: (store) => store.state.selectedDomain,
      builder: (context, selectedDomain) => DropdownMenu<Domain>(
        label: Text("Domain"),
        width: 150,
        enableSearch: false,
        controller: _domainController,
        textStyle: TextStyle(overflow: TextOverflow.ellipsis),
        dropdownMenuEntries: domainEntries,
        onSelected: (changedDomain) {
          if (changedDomain != null) {
            StoreProvider.of<AppState>(context)
                .dispatch(ChangeFilterDomain(changedDomain));
            if (changedDomain == Domain.none) {
              _domainController.clear();
            }
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }

  Widget _genderDropDown(List<DropdownMenuEntry<Gender>> genderEntries) {
    return StoreConnector<AppState, Gender>(
      converter: (store) => store.state.selectedGender,
      builder: (context, selectedGender) => DropdownMenu(
        width: 150,
        label: Text("Gender"),
        enableSearch: false,
        controller: _genderController,
        textStyle: TextStyle(overflow: TextOverflow.ellipsis),
        dropdownMenuEntries: genderEntries,
        onSelected: (changedGender) {
          if (changedGender != null) {
            StoreProvider.of<AppState>(context)
                .dispatch(ChangeFilterGender(changedGender));
            if (changedGender == Gender.none) {
              _genderController.clear();
            }
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }

  Widget _availableCheckBox() {
    return StoreConnector<AppState, bool>(
      converter: (store) => store.state.availableFilter,
      builder: (context, availableFilter) => Checkbox(
        value: availableFilter,
        onChanged: (changedAvailableFilter) {
          if (changedAvailableFilter != null) {
            StoreProvider.of<AppState>(context)
                .dispatch(AddAvailableFilter(changedAvailableFilter));
          }
        },
      ),
    );
  }

  Widget _showTeamList() {
    return StoreConnector<AppState, List<TeamModel>>(
      converter: (store) => store.state.teams,
      builder: (BuildContext context, List<TeamModel> teams) => Expanded(
        child: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return _teamCard(teams[index]);
          },
        ),
      ),
    );
  }

  Widget _teamCard(TeamModel team) {
    // final TeamModel team = teams?[index] ?? TeamModel.errorModel();
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            isThreeLine: true,
            leading: Container(
              margin: EdgeInsets.only(left: 8.0),
              padding: EdgeInsets.all(13.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo,
              ),
              child: Text(team.gender.sexuality.characters.first.toUpperCase()),
            ),
            selected: teamAdded[team.id]!,
            title: Text("${team.firstName} ${team.lastName}"),
            subtitle: Text(
                "${team.email}\n${team.domain.domainName}, ${team.available}"),
          ),
          _addToTeamButton(team),
        ],
      ),
    );
  }

  Widget _addToTeamButton(TeamModel team) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.centerRight,
      child: FilledButton(
        onPressed: (!team.available)
            ? null
            : () {
                setState(() {
                  teamAdded[team.id] = !teamAdded[team.id]!;
                });
                if (teamAdded[team.id] != null && teamAdded[team.id]!) {
                  setState(() {
                    selectionCounter++;
                  });
                } else {
                  setState(() {
                    selectionCounter--;
                  });
                }
              },
        // TODO add an not available text
        child: (!teamAdded[team.id]!)
            ? const Text("Add To Team")
            : const Text("Remove From Team"),
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
          // TODO add a clear all team added button
          // leading:
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
                          (team) => teamAdded[team.id]!,
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

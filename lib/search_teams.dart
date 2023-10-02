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
  Domain selectedDomain = Domain.none;
  Gender selectedGender = Gender.none;
  List<TeamModel>? teams;
  late final List<TeamModel> allTeams;

  Map<int, bool> TeamAdded = <int, bool>{};

  int selectionCounter = 0;

  final _domainController = TextEditingController();

  final _genderController = TextEditingController();

  bool _avaliableFilter = false;

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
      TeamAdded[team.id] = false;
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
            Divider(),
            _searchFilters(),
            Divider(),
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
        onChanged: filterByName,
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

  void filterByName(String query) {
    setState(() {
      teams = allTeams
          .where(
            (item) =>
                item.firstName.toLowerCase().contains(query.toLowerCase()) |
                item.lastName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
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
    return DropdownMenu<Domain>(
      label: Text("Domain"),
      width: 150,
      enableSearch: false,
      controller: _domainController,
      textStyle: TextStyle(overflow: TextOverflow.ellipsis),
      dropdownMenuEntries: domainEntries,
      onSelected: (value) {
        if (value != null) {
          selectedDomain = value;
          if (value == Domain.none) {
            _domainController.clear();
          }
          filter();
          FocusScope.of(context).unfocus();
        }
      },
    );
  }

  Widget _genderDropDown(List<DropdownMenuEntry<Gender>> genderEntries) {
    return DropdownMenu(
      width: 150,
      label: Text("Gender"),
      enableSearch: false,
      controller: _genderController,
      textStyle: TextStyle(overflow: TextOverflow.ellipsis),
      dropdownMenuEntries: genderEntries,
      onSelected: (value) {
        if (value != null) {
          selectedGender = value;
          if (value == Gender.none) {
            _genderController.clear();
          }
          filter();
          FocusScope.of(context).unfocus();
        }
      },
    );
  }

  Widget _availableCheckBox() {
    return Checkbox(
      value: _avaliableFilter,
      onChanged: (_) {
        _avaliableFilter = !_avaliableFilter;
        filter();
      },
    );
  }

  void filter() {
    teams = (selectedDomain == Domain.none)
        ? allTeams
        : allTeams.where((team) => team.domain == selectedDomain).toList();
    teams = (selectedGender == Gender.none)
        ? teams
        : teams?.where((team) => team.gender == selectedGender).toList();
    teams = (_avaliableFilter == false)
        ? teams
        : teams?.where((team) => team.available == _avaliableFilter).toList();
    setState(() {
      teams = teams;
    });
  }

  Widget _showTeamList() {
    return Expanded(
      child: ListView.builder(
        itemCount: teams?.length ?? 0,
        itemBuilder: (context, index) {
          return _teamCard(index);
        },
      ),
    );
  }

  Widget _teamCard(int index) {
    final TeamModel team = teams?[index] ?? TeamModel.errorModel();
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
            selectedColor: Theme.of(context).textSelectionTheme.selectionColor,
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
            selected: TeamAdded[team.id]!,
            title: Text("${team.firstName} ${team.lastName}"),
            subtitle: Text(
                "${team.email}\n${team.domain.domainName}, ${team.available}"),
            trailing: Checkbox(
              onChanged: (!team.available)
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          TeamAdded[team.id] = value;
                        });
                        if (TeamAdded[team.id] != null && TeamAdded[team.id]!) {
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
              value: TeamAdded[team.id],
            ),
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
        child: const Text("Add To Team"),
        onPressed: () {},
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
                          (team) => TeamAdded[team.id]!,
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

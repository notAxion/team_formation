import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:team_formation/models/team_model.dart';
import 'package:team_formation/models/teams_nd_added_member.dart';
import 'package:team_formation/redux/actions.dart';
import 'package:team_formation/redux/app_state.dart';
import 'package:team_formation/team_card.dart';
import 'package:team_formation/team_overview.dart';

class SearchTeams extends StatelessWidget {
  SearchTeams({super.key});

  final TextEditingController editingController = TextEditingController();

  final _domainController = TextEditingController();

  final _genderController = TextEditingController();

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
            _searchBar(context),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(),
                _searchFilters(),
                Divider(),
              ],
            ),
            _showTeamList(context),
            _showOnSelection(context),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            onChanged: (value) => StoreProvider.of<AppState>(context)
                .dispatch(SearchQuery(value)),
            controller: editingController,
            decoration: InputDecoration(
              hintText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              isDense: true,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              editingController.clear();
              StoreProvider.of<AppState>(context).dispatch(SearchQuery(""));
              FocusScope.of(context).unfocus();
            },
            icon: Icon(
              Icons.cancel,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
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
    ;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          limitSize(_domainDropDown(domainEntries)),
          limitSize(_genderDropDown(genderEntries)),
          limitSize(_availableCheckBox()),
        ],
      ),
    );
  }

  Widget limitSize(Widget? child) {
    return SizedBox(
      height: 63,
      child: child,
    );
  }

  Widget _domainDropDown(List<DropdownMenuEntry<Domain>> domainEntries) {
    return StoreConnector<AppState, Domain>(
      converter: (store) => store.state.selectedDomain,
      builder: (context, selectedDomain) => DropdownMenu<Domain>(
        label: Text("Domain"),
        width: 140,
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
        width: 140,
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
      builder: (context, availableFilter) => OutlinedButton(
        onPressed: () {
          StoreProvider.of<AppState>(context).dispatch(
            AddAvailableFilter(!availableFilter),
          );
        },
        child: Text("Available"),
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          backgroundColor:
              (availableFilter) ? Theme.of(context).colorScheme.primary : null,
          foregroundColor: (availableFilter)
              ? Theme.of(context).colorScheme.onPrimary
              : Colors.white70,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
        ),
      ),
    );
  }

  Widget _showTeamList(BuildContext context) {
    return StoreConnector<AppState, List<TeamModel>>(
      converter: (store) => store.state.teams,
      builder: (BuildContext context, List<TeamModel> teams) => Expanded(
        child: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return TeamCard(team: teams[index]);
          },
        ),
      ),
    );
  }

  Widget _showOnSelection(BuildContext context) {
    return StoreConnector<AppState, int>(
      converter: (store) => store.state.selectionCounter,
      builder: (context, selectionCounter) => (selectionCounter < 1)
          ? const SizedBox.shrink()
          : Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: ListTile(
                leading: _clearSelectionButton(context),
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                title: Text("$selectionCounter selected"),
                trailing: _teamOverviewButton(),
              ),
            ),
    );
  }

  Widget _teamOverviewButton() {
    return StoreConnector<AppState, TeamsNdAddedMembers>(
      converter: (store) {
        return TeamsNdAddedMembers(store.state.allTeams, store.state.teamAdded);
      },
      builder: (context, teamsNdAdded) => FilledButton(
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
                final selectedTeams = teamsNdAdded.addedTeams();
                return TeamOverview(
                  selectedTeams: selectedTeams,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _clearSelectionButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        side: BorderSide(
          color: Colors.red,
        ),
        foregroundColor: Colors.red.shade800,
        padding: EdgeInsets.all(10),
      ),
      child: Icon(
        Icons.clear_outlined,
        size: 25,
      ),
      onPressed: () {
        StoreProvider.of<AppState>(context).dispatch(ClearTeamSelection());
      },
    );
  }
}

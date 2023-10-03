import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:team_formation/models/team_model.dart';
import 'package:team_formation/redux/actions.dart';
import 'package:team_formation/redux/app_state.dart';

class TeamCard extends StatelessWidget {
  final TeamModel team;
  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<int, bool>>(
      converter: (store) => store.state.teamAdded,
      builder: (context, teamAdded) => Card(
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
              leading: SizedBox.square(
                dimension: 50,
                child: Image.network(
                  team.avatar,
                  height: 50,
                  width: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person_3_rounded),
                ),
              ),
              selected: teamAdded[team.id]!,
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  "${team.firstName} ${team.lastName}",
                  textScaleFactor: 1.4,
                ),
              ),
              subtitle: Text(
                '''${team.email}
${team.gender.sexuality} - ${team.domain.domainName}''',
              ),
            ),
            _addToTeamButton(context, team, teamAdded[team.id]!),
          ],
        ),
      ),
    );
  }

  Widget _addToTeamButton(
      BuildContext context, TeamModel team, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.centerRight,
      child: (!team.available)
          ? const FilledButton(
              onPressed: null,
              child: Text("Not Available"),
            )
          : FilledButton(
              onPressed: () {
                StoreProvider.of<AppState>(context)
                    .dispatch(AddToTeam(team.id));
              },
              // TODO add an not available text
              child: (!isSelected)
                  ? const Text("Add To Team")
                  : const Text("Remove From Team"),
            ),
    );
  }
}

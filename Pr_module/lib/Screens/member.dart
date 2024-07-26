import 'package:flutter/material.dart';

import 'package:pr/teammember/team_member.dart';

import 'teammember/member_search.dart';


class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<TeamMember> teamMembers = [
    TeamMember("Emily Thompson", "emily.thompson@email.com", "85"),
    TeamMember("Pierre Dubois", "pierre.dubois@email.fr", "90"),
    TeamMember("Oliver Smith", "oliver.smith@email.co.uk", "75"),
    TeamMember("Lukas Müller", "lukas.muller@email.de", "95"),
    TeamMember("Hiroshi Tanaka", "hiroshi.tanaka@email.jp", "80"),
    TeamMember("Jessica Williams", "jessica.williams@email.com", "88"),
    TeamMember("Claire Moreau", "claire.moreau@email.fr", "92"),
    TeamMember("James Taylor", "james.taylor@email.co.uk", "87"),
  ];

  List<TeamMember> filteredMembers = [];
  TeamMember? selectedMember;

  @override
  void initState() {
    super.initState();
    filteredMembers = teamMembers;
  }

  void _filterMembers(String query) {
    final List<TeamMember> results = [];
    if (query.isEmpty) {
      results.addAll(teamMembers);
    } else {
      results.addAll(teamMembers.where((member) =>
          member.name.toLowerCase().contains(query.toLowerCase()) ||
          member.email.toLowerCase().contains(query.toLowerCase()) ||
          member.score.contains(query)));
    }

    setState(() {
      filteredMembers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Members'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: TeamMemberSearchDelegate(teamMembers, _onMemberSelected));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredMembers.length,
        itemBuilder: (context, index) {
          final member = filteredMembers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 89, 125, 89),
              child: Text(member.name[0]),
            ),
            title: Text(
              member.name,
              style:  const TextStyle(fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(member.email),
            trailing: Text(
              member.score,
              style:   const TextStyle(fontWeight: FontWeight.bold
              ,fontSize: 18.5),
            ),
            tileColor: member == selectedMember ? Colors.green : null,
            onTap: () {
              setState(() {
                selectedMember = member;
              });
            },
          );
        },
      ),
    );
  }

  void _onMemberSelected(TeamMember member) {
    setState(() {
      selectedMember = member;
    });
  }
}


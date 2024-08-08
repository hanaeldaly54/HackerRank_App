import 'package:flutter/material.dart';

class TeamPage extends StatefulWidget {
  final bool isAdmin;

  const TeamPage({super.key, required this.isAdmin});
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  // Change this to false to test non-admin view

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

  void _showOptionsDialog(BuildContext context, TeamMember member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Colors.green),
                title: Text('Edit score'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showEditScoreDialog(context, member);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.green),
                title: Text('Remove Member'),
                onTap: () {
                  setState(() {
                    teamMembers.remove(member);
                    filteredMembers.remove(member);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditScoreDialog(BuildContext context, TeamMember member) {
    TextEditingController scoreController =
        TextEditingController(text: member.score);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit score'),
          content: TextField(
            controller: scoreController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter new score"),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save', style: TextStyle(color: Colors.green)),
              onPressed: () {
                setState(() {
                  member.score = scoreController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              showSearch(
                context: context,
                delegate:
                    TeamMemberSearchDelegate(teamMembers, _onMemberSelected),
              );
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(member.email),
            trailing: Text(
              member.score,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.5),
            ),
            tileColor: member == selectedMember ? Colors.green : null,
            onTap: () {
              setState(() {
                selectedMember = member;
              });
              if (widget.isAdmin) {
                _showOptionsDialog(context, member);
              }
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

class TeamMemberSearchDelegate extends SearchDelegate {
  final List<TeamMember> teamMembers;
  final Function(TeamMember) onMemberSelected;

  TeamMemberSearchDelegate(this.teamMembers, this.onMemberSelected);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<TeamMember> results = teamMembers.where((member) {
      return member.name.toLowerCase().contains(query.toLowerCase()) ||
          member.email.toLowerCase().contains(query.toLowerCase()) ||
          member.score.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final member = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 89, 125, 89),
            child: Text(member.name[0]),
          ),
          title: Text(
            member.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(member.email),
          trailing: Text(
            member.score,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            query = member.name;
            onMemberSelected(member);
            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<TeamMember> suggestions = teamMembers.where((member) {
      return member.name.toLowerCase().contains(query.toLowerCase()) ||
          member.email.toLowerCase().contains(query.toLowerCase()) ||
          member.score.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final member = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 89, 125, 89),
            child: Text(member.name[0]),
          ),
          title: Text(
            member.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(member.email),
          trailing: Text(
            member.score,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            query = member.name;
            onMemberSelected(member);
            showResults(context);
          },
        );
      },
    );
  }
}

class TeamMember {
  String name;
  String email;
  String score;

  TeamMember(this.name, this.email, this.score);
}

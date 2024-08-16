import 'package:flutter/material.dart';
import 'package:workshop/widgets/Teammembersearch.dart';
import 'package:workshop/controllar/member_wsprovider.dart';
import 'package:provider/provider.dart';

class TeamscreenWs extends StatefulWidget {
  final bool isAdmin;
  const TeamscreenWs({super.key, required this.isAdmin});

  @override
  State<TeamscreenWs> createState() => _TeamscreenWsState();
}

class _TeamscreenWsState extends State<TeamscreenWs> {
  late Memberprovider memberProvider;

  @override
  void initState() {
    super.initState();
    memberProvider = Provider.of<Memberprovider>(context, listen: false);
    memberProvider.filteredMembers = memberProvider.teamMembers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TeamMemberSearchDelegate(
                    memberProvider.teamMembers, memberProvider.onMemberSelected),
              );
            },
          ),
        ],
      ),
      body: Consumer<Memberprovider>(
        builder: (context, memberprovider, _) {
          return ListView.builder(
            itemCount: memberprovider.filteredMembers.length,
            itemBuilder: (context, index) {
              final member = memberprovider.filteredMembers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 89, 125, 89),
                  child: Text(member.name[0]),
                ),
                title: Text(
                  member.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(member.email),
                tileColor: member == memberprovider.selectedMember ? Colors.green : null,
                onTap: () {
                  memberprovider.selectedMember = member;
                  if (widget.isAdmin) {
                    memberprovider.showOptionsDialog(context, member);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

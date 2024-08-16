import 'package:flutter/material.dart';
import 'package:workshop/models/TeamMember_model.dart';

class Memberprovider with ChangeNotifier {
  List<TeammemberModel> teamMembers = [
    TeammemberModel(name: "Emily Thompson", email: "emily.thompson@email.com"),
    TeammemberModel(name: "Pierre Dubois", email: "pierre.dubois@email.fr"),
    TeammemberModel(name: "Oliver Smith", email: "oliver.smith@email.co.uk"),
    TeammemberModel(name: "Lukas Müller", email: "lukas.muller@email.de"),
    TeammemberModel(name: "Hiroshi Tanaka", email: "hiroshi.tanaka@email.jp"),
    TeammemberModel(
        name: "Jessica Williams", email: "jessica.williams@email.com"),
    TeammemberModel(name: "Claire Moreau", email: "claire.moreau@email.fr"),
    TeammemberModel(name: "James Taylor", email: "james.taylor@email.co.uk"),
  ];

  List<TeammemberModel> filteredMembers = [];
 
   TeammemberModel ? selectedMember;

  void filterMembers(String query) {
    final List<TeammemberModel> results = [];
    if (query.isEmpty) {
      results.addAll(teamMembers);
    } else {
      results.addAll(teamMembers.where((member) =>
          member.name.toLowerCase().contains(query.toLowerCase()) ||
          member.email.toLowerCase().contains(query.toLowerCase())));
    }
    filteredMembers = results;
    notifyListeners();
  }
  void showOptionsDialog(BuildContext context, TeammemberModel member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const  Text('Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:const  Icon(Icons.edit, color: Colors.green),
                title:  const Text('Edit score'),
                onTap: () {
                  Navigator.of(context).pop();
                
                },
              ),
              ListTile(
                leading: const  Icon(Icons.delete, color: Colors.green),
                title:const  Text('Remove Member'),
                onTap: () {
                    teamMembers.remove(member);
                    filteredMembers.remove(member);
                 
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
        notifyListeners();
  }


  void onMemberSelected(TeammemberModel member) {
  
      selectedMember = member;

      notifyListeners();
  }








}

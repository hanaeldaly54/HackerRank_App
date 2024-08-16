import 'package:flutter/material.dart';
import 'package:workshop/Screens/PostswsScreen.dart';
import 'package:workshop/Screens/TaskAdmin_ws.dart';
import 'package:workshop/Screens/TeamScreen_ws.dart';
import 'package:workshop/Screens/material_ws.dart';
import 'package:workshop/Screens/memberTaskScreen_ws.dart';




class HomeWsScreen extends StatelessWidget {
  const HomeWsScreen({super.key});
  final bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
     
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
              labelColor: Color.fromARGB(255, 111, 161, 113),
              dividerColor: Colors.green,
              isScrollable: true,
              indicatorColor: Color.fromARGB(255, 34, 77, 36),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  child: Text(
                    "Members",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                  ),
                ),
                Tab(
                  child: Text(
                    "Tasks",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                  ),
                ),
                Tab(
                  child: Text(
                    "Materials",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                  ),
                ),
                Tab(
                  child: Text("Posts",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w400)),
                ),
              ]),
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              "Workshops",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
               Container(
                height: double.infinity,
                child: TeamscreenWs(isAdmin: isAdmin,),
              ),
           Container(
                height: double.infinity,
                child: isAdmin? TaskAdminWsScreen():MemberTaskScreenWs(),
              ),
              Container(
                height: double.infinity,
                child: MaterialWs(isAdmin: isAdmin,),
              ),
              Container(
                height: double.infinity,
                child:  Postswsscreen(isAdmin:isAdmin ,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

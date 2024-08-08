import 'package:flutter/material.dart';
import 'package:pr/Screens/AdminTaskscreen.dart';
import 'package:pr/Screens/Deals.dart';
import 'package:pr/Screens/material.dart';
import 'package:pr/Screens/member.dart';
import 'package:pr/Screens/memberTask.dart';



class HomePrScreen extends StatelessWidget {
  const HomePrScreen({super.key});
  final bool isAdmin = true;
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
                  child: Text("Deals",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w400)),
                ),
              ]),
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              "Pr committee",
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
                child: TeamPage(isAdmin: isAdmin,),
              ),
              Container(
                height: double.infinity,
                child: isAdmin? TaskScreen():MemberTaskScreen(),
              ),
              Container(
                height: double.infinity,
                child: MaterialScreen(isAdmin: isAdmin,),
              ),
              Container(
                height: double.infinity,
                child:  Deals(isAdmin:isAdmin ,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

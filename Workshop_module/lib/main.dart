import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/Screens/HomeWsScreen.dart';
import 'package:workshop/controllar/TaskMm_wsprovider.dart';
import 'package:workshop/controllar/Task_wsprovider.dart';
import 'package:workshop/controllar/matrial_wsprovider.dart';
import 'package:workshop/controllar/member_wsprovider.dart';
import 'package:workshop/controllar/postswsprovider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=> Memberprovider()),
      ChangeNotifierProvider(create: (context)=>MatrialWsprovider()),
      ChangeNotifierProvider(create: (context)=>TaskmmWsprovider()),
      ChangeNotifierProvider(create: (context)=>TaskWsprovider()),
      ChangeNotifierProvider(create: (context)=>Postswsprovider())

    ],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomeWsScreen(),
    ),
    
    
    );
  }
}
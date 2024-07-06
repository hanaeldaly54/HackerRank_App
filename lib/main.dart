import 'package:flutter/material.dart';
import 'package:it_module/Screens/Homescreen.dart';
import 'package:it_module/widgets/Taskwidgets/provider.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    )
   
    );
  }
}

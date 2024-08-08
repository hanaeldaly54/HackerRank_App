import 'package:flutter/material.dart';
import 'package:pr/Screens/Homeprscreen.dart';
import 'package:pr/controllar/Taskprovider.dart';
import 'package:pr/controllar/pollprovider.dart';
import 'package:pr/controllar/postprovider.dart';
import 'package:provider/provider.dart';

void main() => runApp( const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
providers: [
  ChangeNotifierProvider(create: (context)=> TaskProvider()),
  ChangeNotifierProvider(create: (context)=>Pollprovider()),
  ChangeNotifierProvider(create: (context)=> Postprovider())
],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePrScreen(),
        ));
  }
}

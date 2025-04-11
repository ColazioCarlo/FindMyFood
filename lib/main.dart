import 'package:findmyfood/login/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ovo ce da bude glavi file nez dal cemo ista radit s ovim
  @override
  Widget build(BuildContext context) {
    const appTitle = 'FindMyFood';
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyLoginPage(

      ),
    );
  }
}
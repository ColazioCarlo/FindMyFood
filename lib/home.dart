import 'package:find_my_food/auth.dart';
import 'package:find_my_food/user.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  final UserModel? user;
  const MyHomePage({super.key,this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hi ${authService.username}"),
        ),
    );
  }
}

//ovo je home screen nakon logina, W.I.P.
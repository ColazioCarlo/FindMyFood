import 'package:findmyfood/user.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  final UserModel? user;
  const MyHomePage({super.key,this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hi ${widget.user!.username}"),
        ),
    );
  }
}

//ovo je home screen nakon logina, zasad pametnom dosta
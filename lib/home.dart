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


  Future<void> _handleRefresh() async {
    await authService.refreshAccessToken();

  }

  Future<void> _handleLogout() async {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: _handleLogout,
          ),
          title: Text("Hi ${authService.username}"),
        ),
        //ovaj button je privremen, testiranje za refreshanje tokena
        body:
          Center(
            child: BackButton(
                onPressed: _handleRefresh,
            ),
          )
    );
  }
}

//ovo je home screen nakon logina, W.I.P.
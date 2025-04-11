import 'package:findmyfood/auth.dart';
import 'package:findmyfood/home.dart';
import 'package:flutter/material.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  final _loginKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        key: _loginKey,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),labelText: "Username"),
                    validator: (value){
                      if (value == null|| value.length < 6) {
                        return 'Please enter a valid username';
                      }
                      return null;
                    },
                  ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                ),
                const SizedBox(
                  height: 20,
                ),

                InkResponse(
                  onTap: () async {
                    if (_loginKey.currentState!.validate()) {
                      AuthService authService = AuthService();

                      final user = await authService.login(
                          _usernameController.text, _passwordController.text);

                      if(user!=null){

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage(user: user,)), (route) => false);

                      }
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      if (_loginKey.currentState!.validate()) {
                        // Navigate the user to the Home page
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill input')),
                        );
                      }
                    },
                    child: const Text('Login'),

                  ),
                ),
            ]
          )
        ),
      ),
    );
  }
}

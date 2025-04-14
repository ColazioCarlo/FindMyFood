import 'package:flutter/material.dart';
import 'package:find_my_food/auth.dart';
import 'package:find_my_food/home.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState(); //kreira
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _loginKey = GlobalKey<FormState>(); //drzi login key

  final TextEditingController _usernameController = TextEditingController(); //uzimaju user i pass iz tekstnih polja
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() { //mice widgete
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_loginKey.currentState!.validate()) { //ako ima login key -> poziva login funkciju iz auth.dart
      AuthService authService = AuthService();

      final user = await authService.login(
        _usernameController.text,
        _passwordController.text,
        context,
      );

      if (user != null) { //ako je login uspjesan -> prebaci na home page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(user: user)),
              (route) => false,
        );
      }
    } else { //ako je neuspjesan -> ispisi u snackbaru
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) { //dizajn widgeta
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _loginKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
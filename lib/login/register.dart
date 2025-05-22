import 'dart:ffi' hide Size;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _parkingCountController = TextEditingController();

  bool _isPlace = false;
  bool _hasParking = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _parkingCountController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if(_isPlace){
      _registerPoslovni();
    }
    else {
      _register;
    }
  }

  Future<void> _register() async {
    await AuthService().register(
      _usernameController.text,
      _passwordController.text,
      context
    );
  }

  Future<void> _registerPoslovni() async {
    await AuthService().registerposlovni(
      _usernameController.text,
      _passwordController.text,
      _emailController.text,
      _phoneController.text,
      _addressController.text,
      _parkingCountController.text as Int8,
      _descriptionController.text,
      context
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC4EED7),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/logo.png', height: 150),
              const SizedBox(height: 20),
              const Text(
                'Welcome Onboard!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF235216),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Let's setup your account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF235216),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('I am a place', style: TextStyle(fontSize: 18)),
                        Switch(
                          value: _isPlace,
                          onChanged: (val) => setState(() => _isPlace = val),
                          activeColor: const Color(0xFF00813E),
                        ),
                      ],
                    ),
                    _buildTextField(_usernameController, 'Username'),
                    _buildPasswordField(),
                    if (_isPlace) ...[
                      _buildTextField(_emailController, 'E-mail'),
                      _buildTextField(_phoneController, 'Phone number', maxLength: 9),
                      _buildTextField(_addressController, 'Address'),
                      const Text(
                        'e.g. Prisavlje 3, 10 000 Zagreb',
                        style: TextStyle(color: Color(0xFF235216)),
                      ),
                      Row(
                        children: [
                          const Text('Parking space?', style: TextStyle(fontSize: 18)),
                          Switch(
                            value: _hasParking,
                            onChanged: (val) => setState(() => _hasParking = val),
                            activeColor: const Color(0xFF00813E),
                          ),
                        ],
                      ),
                      if (_hasParking)
                        _buildTextField(_parkingCountController, 'Number of parking spaces', keyboardType: TextInputType.number),
                      _buildTextField(_descriptionController, 'Description', maxLength: 200),
                      const Text(
                        'Describe your place, what kind of food do you serve, etc.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF235216)),
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00813E),
                        minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      child: const Text("Let's Go!", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => const LoginScreen(),
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          children: [
                            TextSpan(
                              text: 'Sign In here',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/login');
                                },
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int? maxLength, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
      ),
    );
  }
}

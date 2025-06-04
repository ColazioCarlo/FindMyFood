import 'dart:ffi';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _parkingCountController = TextEditingController(text: '0');

  bool _isPlace = false;
  bool _hasParking = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _parkingCountController.dispose();
    super.dispose();
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Future<void> _register() async {
    await AuthService().register(
      _usernameController.text,
      _passwordController.text,
      context,
    );
  }

  Future<void> _registerPoslovni() async {
    final int parkingCount = int.tryParse(_parkingCountController.text.trim()) ?? 0;

    await AuthService().registerposlovni(
      _usernameController.text,
      _passwordController.text,
      _nameController.text,
      _emailController.text,
      _phoneController.text,
      _addressController.text,
      parkingCount as Int8,
      _descriptionController.text,
      context,
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isPlace) {
      await _registerPoslovni();
    } else {
      await _register();
    }

    int user = await AuthService().login(
      _usernameController.text,
      _passwordController.text,
      context,
    );

    if (user == 0) {
      Navigator.pushNamed(context, '/map');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
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
                    _buildTextField(_usernameController, 'Username', maxLength: 16),
                    _buildPasswordField(),
                    if (_isPlace) ...[
                      _buildTextField(_nameController, 'Full Name'),
                      _buildTextField(_emailController, 'Email'),
                      _buildTextField(_phoneController, 'Phone Number',
                          keyboardType: TextInputType.phone, maxLength: 10),
                      _buildTextField(_addressController, 'Address', maxLength: 50),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 10),
                        child: Text(
                          'e.g. Prisavlje 3, 10 000 Zagreb',
                          style: TextStyle(color: Color(0xFF235216), fontSize: 14),
                        ),
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Enter description' : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text('Parking space?', style: TextStyle(fontSize: 16)),
                          const Spacer(),
                          Switch(
                            value: _hasParking,
                            onChanged: (val) => setState(() => _hasParking = val),
                            activeColor: const Color(0xFF00813E),
                          ),
                        ],
                      ),
                      if (_hasParking)
                        _buildTextField(
                          _parkingCountController,
                          'Number of parking spaces',
                          keyboardType: TextInputType.number,
                        ),
                    ],
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00813E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _handleRegister,
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: "I have an account... ",
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/login');
                              },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        int? maxLength,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: buildInputDecoration(label),
        validator: (value) => value == null || value.trim().isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_passwordVisible,
        maxLength: 30,
        decoration: buildInputDecoration('Password').copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
          ),
        ),
        validator: (value) => value == null || value.length < 6 ? 'Min 6 characters' : null,
      ),
    );
  }
}

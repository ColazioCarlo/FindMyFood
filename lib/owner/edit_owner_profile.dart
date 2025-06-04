import 'package:flutter/material.dart';

class EditOwnerProfilePage extends StatefulWidget {
  const EditOwnerProfilePage({super.key});

  @override
  State<EditOwnerProfilePage> createState() => _EditOwnerProfilePageState();
}

class _EditOwnerProfilePageState extends State<EditOwnerProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _phoneController    = TextEditingController();
  final TextEditingController _addressController  = TextEditingController();
  final TextEditingController _parkingController  = TextEditingController();
  final TextEditingController _descController     = TextEditingController();

  // Placeholder for a picked image; in a real app, you'd launch image_picker
  ImageProvider? _pickedImage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _parkingController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    Navigator.pushNamed(context, '/login');
  }

  /// Tapping “Upload” just fills in a placeholder image for now.
  void _onPickImage() {
    setState(() {
      _pickedImage = const NetworkImage('https://placehold.co/140x140');
    });
    // TODO: replace with actual image_picker logic
  }

  /// When “Save Changes” is tapped, grab controller.text directly.
  void _onSaveChanges() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email    = _emailController.text.trim();
    final phone    = _phoneController.text.trim();
    final address  = _addressController.text.trim();
    final parking  = _parkingController.text.trim();
    final desc     = _descController.text.trim();

    // TODO: send all these fields (username/password/email/etc) to your backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Saving changes:\n'
              '• Username: $username\n'
              '• Password: $password\n'
              '• E‐mail: $email\n'
              '• Phone: $phone\n'
              '• Address: $address\n'
              '• Parking desc: $parking\n'
              '• Rest desc: $desc\n'
              '(stub…)',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Common corner radius for all fields:
    const double cornerRadius = 20;

    return Scaffold(
      backgroundColor: const Color(0xFFC3ECD5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF68906F),
        title: const Text('Edit Owner Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Upload Images ───────────────────────────────────────────────
              const Text(
                'Upload your image:',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Actor',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: _onPickImage,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: _pickedImage,
                    child: _pickedImage == null
                        ? const Icon(
                      Icons.camera_alt,
                      size: 48,
                      color: Color(0xFF5B5454),
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: _onPickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008245),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Actor',
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Divider(thickness: 1.2),
              const SizedBox(height: 24),

              // ── Profile Fields ─────────────────────────────────────────────
              _buildRoundedField(
                controller: _usernameController,
                hintText: 'Username',
                borderRadius: cornerRadius,
              ),
              const SizedBox(height: 16),
              _buildRoundedField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
                borderRadius: cornerRadius,
              ),
              const SizedBox(height: 16),
              _buildRoundedField(
                controller: _emailController,
                hintText: 'E‐mail',
                keyboardType: TextInputType.emailAddress,
                borderRadius: cornerRadius,
              ),
              const SizedBox(height: 16),
              _buildRoundedField(
                controller: _phoneController,
                hintText: 'Phone number',
                keyboardType: TextInputType.phone,
                borderRadius: cornerRadius,
              ),
              const SizedBox(height: 16),
              _buildRoundedField(
                controller: _addressController,
                hintText: 'Address',
                helperText: 'e.g. Prisavlje 3, 10 000 Zagreb',
                borderRadius: cornerRadius,
              ),
              const SizedBox(height: 16),
              _buildRoundedField(
                controller: _parkingController,
                hintText: 'Parking space?',
                helperText: 'Describe your place. What kind of food you serve?',
                maxLines: 3,
                borderRadius: cornerRadius,
              ),
              const SizedBox(height: 16),
              // Example “Restaurant description” field
              _buildRoundedField(
                controller: _descController,
                hintText: 'Restaurant description',
                helperText: 'Tell us more about your restaurant.',
                maxLines: 3,
                borderRadius: cornerRadius,
              ),
              const SizedBox(height: 32),

              // “Save Changes” button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _onSaveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008245),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Actor',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008245),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Actor',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // ── Bottom navigation bar ───────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00813E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: 2, // “Profile” is index 2
        onTap: (index) {
          if (index == 0) {
            // ▶︎ Now navigate to /benefits
            Navigator.pushNamed(context, '/currbenefits');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/currconditions');
          } else if (index == 2) {
            // Already on Profile → do nothing
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Benefits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Current',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  /// Helper to build a rounded‐corner text field with optional helper text.
  Widget _buildRoundedField({
    required TextEditingController controller,
    required String hintText,
    String? helperText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    double borderRadius = 20,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wrap the TextField in a Material so the shadow
        // respects the rounded corners.
        Material(
          elevation: 4,
          shadowColor: const Color(0x3F000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              // Keep the same rounded corners when focused:
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0D5835),
              fontFamily: 'Actor',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

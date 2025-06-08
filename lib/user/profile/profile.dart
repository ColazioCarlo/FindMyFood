import 'package:flutter/material.dart';
import '../../login/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<ProfilePage> {
  final authService = AuthService();


  Future<void> _handleRefresh() async {
    await authService.refreshAccessToken();

  }

  Future<void> _handleLogout() async {
    Navigator.pushNamed(context, '/login');
  }

  // Example data
  final List<String> _futureReservations = const [
    'Restaurant 1',
    'Restaurant 2',
    'Restaurant 3',
    'Restaurant 4',
    'Restaurant 5',
    'Restaurant 6',
    'Restaurant 7',
  ];

  final List<String> _pastReservations = const [
    // Leave empty for now. Could add sample past reservations if desired.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3ECD5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Wallet / Balance Card ────────────────────────────────────────
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFF2E8E8),
                elevation: 4,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Current balance:" and icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current balance:',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Actor',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00813E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Balance amount field
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '152€',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Actor',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,

                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Transfer more funds',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF07490C),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Enter amount:',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        height: 50,
                        child: TextField(
                          keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Actor',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Transfer button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            _handleRefresh();
                            // TODO: connect to backend to process transfer
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Transfer initiated'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF008245),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Transfer',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Actor',
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Future & Past Reservations Card ───────────────────────────────
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFF2E8E8),
                elevation: 4,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Future reservations:',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _futureReservations.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final restaurantName = _futureReservations[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  restaurantName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Actor',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF745F5F),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 36,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // TODO: navigate to reservation details
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Selected $restaurantName'),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF136E49),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                    ),
                                    child: const Text(
                                      'SELECT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Actor',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Divider(color: Colors.grey, thickness: 1),
                      const SizedBox(height: 16),

                      // Past reservations
                      const Text(
                        'Past reservations:',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (_pastReservations.isEmpty)
                        const Center(
                          child: Text(
                            'No past reservations yet.',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Actor',
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _pastReservations.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final restaurantName = _pastReservations[index];
                            return Text(
                              restaurantName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Actor',
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF745F5F),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Benefits Card ───────────────────────────────────────────────
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFF2E8E8),
                elevation: 4,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Your current benefits" title
                      const Text(
                        'Your current benefits',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF125D3F),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // "Fidelity points:" section
                      const Text(
                        'Fidelity points:',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2E8E8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Restaurant 1: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Actor',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF745F5F),
                                ),
                              ),
                              TextSpan(
                                text: '30\n',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Actor',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF125D3F),
                                ),
                              ),
                              TextSpan(
                                text: '\nRestaurant 2: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Actor',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF745F5F),
                                ),
                              ),
                              TextSpan(
                                text: '25',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Actor',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF125D3F),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Vouchers:',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2E8E8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Restaurant 1: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Actor',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF745F5F),
                                ),
                              ),
                              TextSpan(
                                text: '10% off\n',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Actor',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF125D3F),
                                ),
                              ),
                              TextSpan(
                                text: '\nRestaurant 2: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Actor',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF745F5F),
                                ),
                              ),
                              TextSpan(
                                text: 'none',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Actor',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF125D3F),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 60,
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
                      fontWeight: FontWeight.w600,
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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00813E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: 2, // “Profile” is index 2
        onTap: (index) {
          if (index == 0) {
            // Navigate to Map page
            Navigator.pushNamed(context, '/map');
          } else if (index == 1) {
            // Navigate to Restaurant List
            Navigator.pushNamed(context, '/list');
          } else if (index == 2) {
            // Already on “Profile” → do nothing
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

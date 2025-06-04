import 'package:flutter/material.dart';

class CurrentConditionsPage extends StatefulWidget {
  const CurrentConditionsPage({super.key});

  @override
  State<CurrentConditionsPage> createState() => _CurrentConditionsPageState();
}

class _CurrentConditionsPageState extends State<CurrentConditionsPage> {
  final TextEditingController _parkingController = TextEditingController();
  final TextEditingController _tablesController = TextEditingController();

  @override
  void dispose() {
    _parkingController.dispose();
    _tablesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Spacing between each field block
    const double verticalBlockSpacing = 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFC3ECD5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF68906F),
        centerTitle: true,
        title: const Icon(
          Icons.business_center, // suitcase / briefcase icon
          color: Colors.white,
          size: 32,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // ── Page Title ───────────────────────────────────────────────
            Center(
              child: Text(
                'Update current conditions',
                style: const TextStyle(
                  color: Color(0xFF1D6729),
                  fontSize: 28,
                  fontFamily: 'Actor',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            // ── Current Parking Spots ──────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current parking spots:',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Actor',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _parkingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF2E8E8),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: send _parkingController.text.trim() to your backend
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF008245),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Actor',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: verticalBlockSpacing),

            // ── Current Tables Available ────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current tables available:',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Actor',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _tablesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF2E8E8),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: send _tablesController.text.trim() to your backend
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF008245),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Actor',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ovdje dodaj buduce blokove
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00813E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: 1, // “Current” is index 1
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/currbenefits');
          } else if (index == 1) {
            // Already here → do nothing
          } else if (index == 2) {
            Navigator.pushNamed(context, '/ownprofile');
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
}

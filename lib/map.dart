import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full‐screen placeholder map image
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_placeholder.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/list');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008245),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Center(
                    child: Text(
                      'Find My Food!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Actor',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00813E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on Map → do nothing
          } else if (index == 1) {
            // Go to Restaurant List
            Navigator.pushNamed(context, '/list');
          } else if (index == 2) {
            // Go to Profile
            Navigator.pushNamed(context, '/userprofile');
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

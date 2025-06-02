// lib/map.dart

import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Stack so that we can place the map image behind and the button on top
      body: Stack(
        children: [
          // Full‐screen placeholder map image
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_placeholder.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // “Find My Food!” button at bottom center
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: SizedBox(
                width: double.infinity,
                height: 60, // a bit taller for better centering
                child: ElevatedButton(
                  onPressed: () {
                    // Push to restaurant_list.dart (route '/list')
                    Navigator.pushNamed(context, '/list');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008245),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: EdgeInsets.zero, // ensures full-size coverage
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

      // Bottom navigation bar shared across Reservation, List, Profile, and now Map
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00813E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: 0, // “Map” is index 0 when on MapPage
        onTap: (index) {
          if (index == 0) {
            // Already on Map → do nothing
          } else if (index == 1) {
            // Go to Restaurant List
            Navigator.pushNamed(context, '/list');
          } else if (index == 2) {
            // Go to Profile
            Navigator.pushNamed(context, '/profile');
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

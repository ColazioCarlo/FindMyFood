// lib/restaurant_list.dart

import 'package:flutter/material.dart';
import 'reservation.dart';


class RestaurantItem extends StatelessWidget {
  final String title;

  const RestaurantItem({
    super.key,
    required this.title,
  });

  static const double itemHeight = 250;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1) Restaurant Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00813E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Text(
                          'Review:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(
                            4,
                                (index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Tables available: 5',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Parking spots left: 10',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const Spacer(),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReservationPage(
                                restaurantName: title,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF136E49),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 10,
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'SELECT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/placeholder.png',
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  static const List<String> _restaurantTitles = [
    'Restaurant 1',
    'Restaurant 2',
    'Restaurant 3',
    'Restaurant 4',
    'Restaurant 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 16, bottom: 80),
        itemCount: _restaurantTitles.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final title = _restaurantTitles[index];
          return RestaurantItem(title: title);
        },
      ),


      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00813E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: 1, // “List” is index 1
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            // Already on “List” → do nothing
          } else if (index == 2) {
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

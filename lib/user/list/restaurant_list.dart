import '../../model/place.dart';
import '/user/list/getPlaces.dart';
import 'package:flutter/material.dart';
import 'reservation/reservation.dart';

//generiranje itema na listi
class RestaurantItem extends StatelessWidget {
  final PlaceModel mjesto;

  const RestaurantItem({
    super.key,
    required this.mjesto,
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
                    Text(
                      mjesto.name!,
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
                          'Ocjene:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          mjesto.rating.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Slobodno mjesto: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          mjesto.parkingFree.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mjesto.opis!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReservationPage(mjesto: mjesto),
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
                child: Image.network(
                  mjesto.photoUri!,
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

//lista stranice

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key}) ;

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  late Future<List<PlaceModel>> _restaurants;

  final double longitude = 14.4464342;
  final double latitude = 45.3273731;
  final int radius = 5000; //zasad

  @override
  void initState() {
    super.initState();
    _restaurants = GetPlaces().getPlaces(
      longitude.toString(),
      latitude.toString(),
      radius.toString(),
      null,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: FutureBuilder<List<PlaceModel>>(
        future: _restaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No restaurants found.'));
          }

          final restaurants = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.only(top: 16, bottom: 80),
            itemCount: restaurants.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final place = restaurants[index];
              return RestaurantItem(mjesto: place);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00813E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: 1,
        // index 1 = “List”
        onTap: (index) {
          if (index == 0) {
            // Navigate to Map
            Navigator.pushNamed(context, '/map');
          } else if (index == 1) {
            // Already on “List” → do nothing
          } else if (index == 2) {
            // Navigate to Profile
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


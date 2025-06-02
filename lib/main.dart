import 'package:flutter/material.dart';

// Existing imports:
import 'package:find_my_food/login/register.dart';
import 'home.dart';
import 'login/login.dart';

// NEW imports for your existing screens:
import 'restaurant_list.dart';
import 'reservation.dart';
import 'use_benefits_before_paying.dart';
import 'pay.dart';

// Import your Edit Owner Profile page:
import 'edit_owner_profile.dart';

// Import the new Current Conditions page:
import 'current_conditions.dart';

// Import the new Edit Benefits page:
import 'edit_benefits.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'FindMyFood';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),

      // Launch straight into the Edit Owner Profile page:
      home: const EditOwnerProfilePage(),

      // ───────────────────────────────────────────────────────────────────
      // ROUTES MAP
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const MyHomePage(),
        '/list': (_) => const RestaurantListPage(),

        // “Reservation” route only needs restaurantName:
        '/reservation': (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ReservationPage(
            restaurantName: args['restaurantName'] as String,
          );
        },

        // “Use Benefits” route needs all five parameters:
        '/use_benefits': (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return UseBenefitsPage(
            restaurantName: args['restaurantName'] as String,
            reservationDate:
            DateTime.parse(args['reservationDate'] as String),
            reservationTime:
            stringToTimeOfDay(args['reservationTime'] as String),
            fidelityPoints: args['fidelityPoints'] as int,
            voucherCode: args['voucherCode'] as String,
          );
        },

        // “Pay” route (uses placeholder camera view for now):
        '/pay': (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PayPage(
            originalSum: args['originalSum'] as int,
            discountedSum: args['discountedSum'] as int,
          );
        },

        // NEW: Route for “Current Conditions” screen
        '/current_conditions': (context) => const CurrentConditionsPage(),

        // NEW: Route for “Profile” screen (i.e. Edit Owner Profile)
        '/profile': (context) => const EditOwnerProfilePage(),

        // NEW: Route for “Benefits” screen (EditBenefitsPage)
        '/benefits': (context) => const EditBenefitsPage(),
      },
    );
  }
}

/// Top‐level helper to convert an “HH:mm” string into a TimeOfDay.
/// Moving this out of MyApp so it’s in scope for the route closures.
TimeOfDay stringToTimeOfDay(String timeString) {
  final parts = timeString.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

import 'package:find_my_food/login/pocetna.dart';
import 'package:find_my_food/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:find_my_food/login/register.dart';
import 'login/login.dart';
import 'owner/current_conditions.dart';
import 'owner/edit_benefits.dart';
import 'owner/edit_owner_profile.dart';
import 'user/restaurant_list.dart';
import 'user/reservation.dart';
import 'user/use_benefits_before_paying.dart';
import 'user/pay.dart';
import 'user/map.dart';

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
      initialRoute: '/pocetna',
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


      routes: {
        '/map': (context) => const MapPage(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/list': (_) => RestaurantListPage(),
        '/pocetna': (_) => const MyFirstPage(),
        '/currconditions': (_) => const CurrentConditionsPage(),
        '/currbenefits': (_) => const EditBenefitsPage(),
        '/ownprofile': (_) => const EditOwnerProfilePage(),
        '/userprofile': (_) => const ProfilePage(),

        // “Reservation” route only needs restaurantName:
        '/reservation': (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ReservationPage(
            mjesto: args['mjesto'],
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
            _stringToTimeOfDay(args['reservationTime'] as String),
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
      },
    );
  }

  /// Helper to convert an “HH:mm” string into a TimeOfDay.
  static TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}

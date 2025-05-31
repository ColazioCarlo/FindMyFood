// lib/main.dart

import 'package:flutter/material.dart';

// Existing imports for actual routes/widgets you use:
import 'package:find_my_food/login/register.dart';
import 'home.dart';
import 'login/login.dart';

// NEW: import your restaurant list screen
import 'restaurant_list.dart';

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

      // If you want the app to start on your “list” page by default:
      initialRoute: '/list',

      // Authentication & home routes:
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),

        // “Home” screen:
        '/home': (_) => const MyHomePage(),

        // Restaurant list screen:
        '/list': (_) => const RestaurantListPage(),

        // (If you add a profile page later, register '/profile' here.)
      },
    );
  }
}

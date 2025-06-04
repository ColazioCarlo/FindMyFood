import 'dart:ui';
import 'package:flutter/material.dart';

class UseBenefitsPage extends StatelessWidget {
  final String restaurantName;
  final DateTime reservationDate;
  final TimeOfDay reservationTime;
  final int fidelityPoints;
  final String voucherCode;

  const UseBenefitsPage({
    super.key,
    required this.restaurantName,
    required this.reservationDate,
    required this.reservationTime,
    required this.fidelityPoints,
    required this.voucherCode,
  });

  String get _formattedDate {
    final day = reservationDate.day.toString();
    final year = reservationDate.year.toString();
    final monthNames = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final monthName = monthNames[reservationDate.month];
    return '$day $monthName $year';
  }

  String get _formattedTime {
    final hour = reservationTime.hour.toString().padLeft(2, '0');
    final minute = reservationTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDEE9E7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 220,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'You have successfully reserved',
                        style: TextStyle(
                          color: Colors.black.withAlpha(178),
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: restaurantName,
                        style: const TextStyle(
                          color: Color(0xFF0D5935),
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: 'for',
                        style: TextStyle(
                          color: Colors.black.withAlpha(176),
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: '$_formattedDate\n@ $_formattedTime',
                        style: const TextStyle(
                          color: Color(0xFF0D5935),
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Open this reservation when paying to enjoy ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                      const TextSpan(
                        text: 'discounts',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          height: 1.20,
                        ),
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                      const TextSpan(
                        text: 'benefits',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          height: 1.20,
                        ),
                      ),
                      const TextSpan(
                        text: ' and gain fidelity ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                      const TextSpan(
                        text: 'points',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          height: 1.20,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Available fidelity points for $restaurantName:',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Actor',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      width: 139,
                      height: 38,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF2E8E8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        fidelityPoints.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 107,
                      height: 41,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF008245),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // TODO: hook up fidelity points usage with backend
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Using $fidelityPoints points'),
                            ),
                          );
                        },
                        child: const Text(
                          'Use',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Actor',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*1 point = 0.1 Euros',
                    style: TextStyle(
                      color: Color(0xFF0D5935),
                      fontSize: 16,
                      fontFamily: 'Actor',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Available voucher for $restaurantName:',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Actor',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      width: 139,
                      height: 38,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF2E8E8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        voucherCode,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Actor',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 107,
                      height: 41,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF008245),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // TODO: hook up voucher usage with backend
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Using voucher $voucherCode'),
                            ),
                          );
                        },
                        child: const Text(
                          'Use',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Actor',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 290,
                height: 74,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/pay',
                      arguments: {
                        'originalSum': 78,    // TODO: replace with real amount from backend
                        'discountedSum': 71,  // TODO: replace with real discounted amount
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008245),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'PAY WITH QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Actor',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 159,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/list'));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF63917C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Center(
                    child: Text(
                      'Quit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Actor',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

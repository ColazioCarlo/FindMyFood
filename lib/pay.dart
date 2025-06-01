// lib/pay.dart

import 'package:flutter/material.dart';

class PayPage extends StatelessWidget {
  final int originalSum;
  final int discountedSum;

  const PayPage({
    super.key,
    required this.originalSum,
    required this.discountedSum,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with QR'),
        backgroundColor: const Color(0xFF008245),
      ),
      body: Column(
        children: [
          // 1) Payment summary at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Original: $originalSum €   Discounted: $discountedSum €',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // 2) Placeholder rectangle (instead of a real camera view)
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E8E8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF63917C),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'QR Placeholder',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF745F5F),
                      fontFamily: 'Actor',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3) “Done” button (just returns to previous screen)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008245),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/pay.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PayPage extends StatefulWidget {
  final int originalSum;
  final int discountedSum;

  const PayPage({
    super.key,
    required this.originalSum,
    required this.discountedSum,
  });

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  /// Controller for the mobile scanner (camera + flash + front/back).
  ///
  /// We start with the default settings. You can tweak resolution,
  /// detection speed, etc. by passing named arguments here if needed.
  final MobileScannerController _scannerController = MobileScannerController();

  /// This method is called each time the scanner sees at least one barcode.
  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isEmpty) return;
    final barcode = capture.barcodes.first;
    final rawValue = barcode.rawValue;
    if (rawValue == null) return;

    // Pause the camera immediately to avoid repeated scans:
    _scannerController.stop();

    // Just print for now—backend logic to come later.
    debugPrint('🔥 Scanned QR/Barcode: $rawValue');

    // TODO: send `rawValue` to your backend to process the payment.
    //       Once your server confirms success, maybe show a Dialog or navigate back.
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with QR'),
        backgroundColor: const Color(0xFF008245),
      ),
      body: Column(
        children: [
          // ── 1) Payment summary ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Original: ${widget.originalSum} €   Discounted: ${widget.discountedSum} €',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // ── 2) Camera Preview / QR Scanner ─────────────────────────────────
          Expanded(
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
              // A simple overlay: darken the screen & cut out a center square with a green border.
              overlayBuilder: (context, constraints) {
                final scanSize = constraints.maxWidth * 0.8;
                final horizontalPadding = (constraints.maxWidth - scanSize) / 2;
                final verticalPadding = (constraints.maxHeight - scanSize) / 2;
                return Stack(
                  children: [
                    // Dark overlay over the entire area
                    Container(color: Colors.black.withValues(alpha: 0.4)),
                    // Transparent square in the center with a green border
                    Positioned(
                      left: horizontalPadding,
                      top: verticalPadding,
                      width: scanSize,
                      height: scanSize,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.shade700,
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EditBenefitsPage extends StatefulWidget {
  const EditBenefitsPage({super.key});

  @override
  State<EditBenefitsPage> createState() => _EditBenefitsPageState();
}

class _EditBenefitsPageState extends State<EditBenefitsPage> {
  final TextEditingController _visitsController     = TextEditingController();
  final TextEditingController _discountController   = TextEditingController();
  final TextEditingController _conversionController = TextEditingController();

  @override
  void dispose() {
    _visitsController.dispose();
    _discountController.dispose();
    _conversionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Spacing between each block
    const double verticalBlockSpacing = 32.0;

    return Scaffold(
      backgroundColor: const Color(0xFFC3ECD5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF68906F),
        centerTitle: true,
        title: const Icon(
          Icons.favorite_border, // heart icon
          color: Colors.white,
          size: 32,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // ── Page Title ───────────────────────────────────────────────
                Center(
                  child: Text(
                    'Edit customer loyalty\nbenefits',
                    style: const TextStyle(
                      color: Color(0xFF1D6729),
                      fontSize: 32,
                      fontFamily: 'Actor',
                      fontWeight: FontWeight.w400,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 48),

                // ── Block #1: Visits until Voucher ────────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'After how many visits would you\nlike to generate voucher\nfor your customer?',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Actor',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Input box (light pink background)
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _visitsController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF2E8E8),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // “Save” button
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Save visits logic
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF008245),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Actor',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: verticalBlockSpacing),

                // ── Block #2: Discount Percentage ────────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                            'How much discount would you\nlike a voucher to enable?\n\n',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Actor',
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: 'e.g. 10 %\n',
                            style: const TextStyle(
                              color: Color(0xFF008245),
                              fontSize: 18,
                              fontFamily: 'Actor',
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Input box
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _discountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF2E8E8),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // “Save” button
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Save discount logic
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF008245),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Actor',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: verticalBlockSpacing),

                // ── Block #3: Conversion Rate ─────────────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter conversion rate for fidelity\npoints. E.g. if you put 0.1, customer\ngets 1 point for 10 Euros spent and\ngains 1 Euro discount',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Actor',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Input box
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _conversionController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF2E8E8),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // “Save” button
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Save conversion logic
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF008245),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Actor',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),

      // ── Bottom Navigation Bar ───────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00813E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: 0, // “Benefits” is index 0
        onTap: (index) {
          if (index == 0) {
            // Already on Benefits → do nothing
          } else if (index == 1) {
            Navigator.pushNamed(context, '/currconditions');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/ownprofile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Benefits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Current',
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

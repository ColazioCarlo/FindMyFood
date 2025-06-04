import 'package:flutter/material.dart';
import 'profile.dart';

class ReservationPage extends StatefulWidget {
  final String restaurantName;

  const ReservationPage({
    super.key,
    required this.restaurantName,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String get _dateText {
    if (_selectedDate == null) return 'DD/MM/YYYY';
    final d = _selectedDate!;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$month/$year';
  }

  String get _timeText {
    if (_selectedTime == null) return '00:00';
    final t = _selectedTime!;
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final nowTime = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: nowTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Please choose time and date of your arrival at ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Actor',
                        fontWeight: FontWeight.w400,
                        height: 1.40,
                      ),
                    ),
                    TextSpan(
                      text: widget.restaurantName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Actor',
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        height: 1.40,
                      ),
                    ),
                    const TextSpan(
                      text: ':',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Actor',
                        fontWeight: FontWeight.w400,
                        height: 1.40,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: 298,
                height: 50,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 19),
                child: Text(
                  _dateText,
                  style: const TextStyle(
                    color: Color(0xA35B5454),
                    fontSize: 20,
                    fontFamily: 'Actor',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                width: 298,
                height: 50,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 19),
                child: Text(
                  _timeText,
                  style: const TextStyle(
                    color: Color(0xA35B5454),
                    fontSize: 20,
                    fontFamily: 'Actor',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 290,
              height: 74,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedDate == null || _selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please choose both date and time.'),
                      ),
                    );
                    return;
                  }
                  final hour = _selectedTime!.hour.toString().padLeft(2, '0');
                  final minute =
                  _selectedTime!.minute.toString().padLeft(2, '0');
                  final time24 = '$hour:$minute';

                  Navigator.pushNamed(
                    context,
                    '/use_benefits',
                    arguments: {
                      'restaurantName': widget.restaurantName,
                      'reservationDate': _selectedDate!.toIso8601String(),
                      'reservationTime': time24,
                      'fidelityPoints': 150,   // TODO
                      'voucherCode': '5GH79Y', // TODO
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
                  'Reserve!',
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
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Or ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Actor',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF63917C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Go back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Actor',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
                const Text(
                  ' to the list',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Actor',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF00813E),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 1, // Highlight “List” in black when on Reservation
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/map');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/list');
          } else if (index == 2) {
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

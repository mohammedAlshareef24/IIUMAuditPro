import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Report_pages/SubmitReportPage.dart';
import 'BottomNavigationBarWidget.dart';
import 'LogoWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: LogoWidget(showBackButton: false),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FadeIn(
            duration: const Duration(milliseconds: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 26),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Raise issues anywhere',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                const Text(
                  'Report any non-compliance issues within the IIUM’s for prompt resolution and a safer environment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 58),
                Container(
                  width: 345,
                  height: 63,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                   
                      color: Colors.yellow[600],
               
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const SubmitReportPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                          size:20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Submit Report',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 42),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency numbers',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
  _buildEmergencyIconWithText(
  color: const Color.fromRGBO(110, 103, 217, 0.50),
  icon: Icons.local_hospital,
  phoneNumber: "tel:+60364214444",
  size: 60,
  text: 'Clinic',
  textStyle: const TextStyle(color: Colors.black), // Set text color to black
),
  _buildEmergencyIconWithText(
    color: const Color.fromRGBO(7, 123, 163, 0.50),
    icon: Icons.local_police,
    phoneNumber: "tel:+60364215555",
    size: 60,
    text: 'OSEM',
    textStyle: const TextStyle(color: Colors.black), // Set text color to black
  ),
  _buildEmergencyIconWithText(
    color: const Color.fromRGBO(255, 212, 0, 0.50),
    icon: Icons.local_fire_department,
    phoneNumber: "tel:999",
    size: 60,
    text: 'Bomba',
    textStyle: const TextStyle(color: Colors.black), // Set text color to black
  ),
],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildEmergencyIconWithText({
  required Color color,
  required IconData icon,
  required String phoneNumber,
  required double size,
  required String text,
  required TextStyle textStyle,
}) {
  return Column(
    children: [
      GestureDetector(
        onTap: () {
          _callPhoneNumber(phoneNumber);
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: Icon(
            icon,
            color: Colors.black, // Set icon color to black
            size: size * 0.6,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        text,
        style: textStyle, // Use the provided textStyle
      ),
    ],
  );
}


  Future<void> _callPhoneNumber(String phoneNumber) async {
    try {
      await launch(phoneNumber);
    } catch (e) {
      print("Error launching phone call: $e");
    }
  }
}

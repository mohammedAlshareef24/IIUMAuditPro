import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'BottomNavigationBarWidget.dart';
import 'LogoWidget.dart'; // Import your LogoWidget

class EmergencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LogoWidget(),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 248, 248), // Set the background color to #E5E5E5
      body: const SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Emergency Numbers',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32.0),
                // Add your emergency contact buttons here
                EmergencyContactButton(
                  department: 'Clinic',
                  icon: Icons.local_hospital,
                  phoneNumber: 'tel:+60364214444',
                ),
                SizedBox(height: 16.0),
                EmergencyContactButton(
                  department: 'OSEM',
                  icon: Icons.local_police,
                  phoneNumber: 'tel:+60364215555',
                ),
                SizedBox(height: 16.0),
                EmergencyContactButton(
                  department: 'ITD',
                  icon: Icons.wifi_outlined,
                  phoneNumber: 'tel:6095183435',
                ),
                SizedBox(height: 16.0),
                EmergencyContactButton(
                  department: 'AMAD',
                  icon: Icons.edit_document,
                  phoneNumber: 'tel:+60364216421',
                ),
                SizedBox(height: 16.0),
                EmergencyContactButton(
                  department: 'FINANCE',
                  icon: Icons.attach_money_rounded,
                  phoneNumber: 'tel:+60364214000',
                ),
                SizedBox(height: 16.0),
                EmergencyContactButton(
                  department: 'VISA UNIT',
                  icon: Icons.card_travel,
                  phoneNumber: 'tel:+60364215841',
                ),
                SizedBox(height: 16.0),
                EmergencyContactButton(
                  department: 'DAYA BERSIH',
                  icon: Icons.manage_accounts,
                  phoneNumber: 'tel:+60341625560',
                ),
                SizedBox(height: 16.0),
                EmergencyContactButton(
                  department: 'BOMBA',
                  icon: Icons.local_fire_department_outlined,
                  phoneNumber: 'tel:999',
                ),
                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}

class EmergencyContactButton extends StatefulWidget {
  final String department;
  final IconData icon;
  final String phoneNumber;

  const EmergencyContactButton({
    Key? key,
    required this.department,
    required this.icon,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _EmergencyContactButtonState createState() => _EmergencyContactButtonState();
}

class _EmergencyContactButtonState extends State<EmergencyContactButton> {
  bool showPhoneNumber = false;

@override
Widget build(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5.0, // Adjust the blur radius for the shadow
          offset: Offset(0, 3), // Adjust the offset for the shadow
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: () {
        _callPhoneNumber(widget.phoneNumber);
      },
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            color: Colors.black,
            size: 32.0,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.department,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Visibility(
                  visible: showPhoneNumber,
                  child: Text(
                    widget.phoneNumber,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showPhoneNumber = !showPhoneNumber;
              });
            },
            child: const Icon(
              Icons.phone_in_talk,
              color: Colors.green,
              size: 32.0,
            ),
          ),
        ],
      ),
    ),
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

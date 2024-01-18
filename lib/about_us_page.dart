import 'package:audit/LogoWidget.dart';
import 'package:flutter/material.dart';
import 'BottomNavigationBarWidget.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LogoWidget(),
        automaticallyImplyLeading: false,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'About Us',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to IIUM AuditPro, the mobile application designed for students and staff of the International Islamic University of Malaysia (IIUM) to report non-compliance issues within IIUM campus. Our goal is to improve the efficiency and effectiveness of the audit process, creating a safer and more compliant environment for everyone at IIUM.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Problem',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Non-compliance issues, ranging from building maintenance problems to safety hazards and policy violations, can negatively impact the student and staff experience at IIUM. The traditional audit process is time-consuming and resource-intensive, leading to delayed responses and administrative burdens.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontStyle: FontStyle.italic,

                ),
              ),
              SizedBox(height: 24),
              Text(
                'Solution',
                style: TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'IIUM AuditPro simplifies the reporting process, allowing users to easily submit reports from their mobile devices. With the ability to upload photos or videos, our audit team can better understand the issues and take prompt action. Our objective is to enhance IIUM\'s facilities and provide better services.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Features',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '- Authentication system for secure access.\n'
                '- Easy reporting of non-compliance issues with photo uploads.\n'
                '- Real-time tracking of report progress and updates.\n'
                '- Emergency contacts for easy access to   relevant departments.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Join us in creating a more compliant and safer environment at IIUM with IIUM AuditPro.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on the About Us page
              break;
            case 1:
              Navigator.of(context).pushReplacementNamed('/emergency');
              break;
            case 2:
              Navigator.of(context).pushReplacementNamed('/home');
              break;
            case 3:
              Navigator.of(context).pushReplacementNamed('/progress');
              break;
            case 4:
              Navigator.of(context).pushReplacementNamed('/profile');
              break;
          }
        },
      ),
    );
  }
}

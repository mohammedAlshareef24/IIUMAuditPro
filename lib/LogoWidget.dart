import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: LogoWidget(showBackButton: true), // Pass the parameter here
          actions: [
            // Add your actions here if needed
          ],
        ),
        body: Center(
          child: Text('Your main content goes here'),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  final bool showBackButton;

  LogoWidget({this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (showBackButton)
          Align(
            alignment: Alignment.centerLeft,
            child: BackButton(), // Display the back button
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Replace 'assets/logo.png' with your actual logo path
              height: 40, // Adjust the height of the logo
              width: 40, // Adjust the width of the logo
            ),
            SizedBox(width: 8),
            Text(
              'IIUM AuditPro',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(MyApp());
}

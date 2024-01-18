import 'package:audit/Report_pages/facilites_page.dart';
import 'package:audit/Report_pages/kuliyyah_page.dart';
import 'package:flutter/material.dart';
import 'package:audit/Report_pages/mahallah_page.dart'; // Make sure this is the correct import path
import 'package:audit/Report_pages/other_page.dart'; // Make sure this is the correct import path
import '../LogoWidget.dart'; // Import LogoWidget

class SubmitReportPage extends StatelessWidget {
  const SubmitReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,

  title: LogoWidget(showBackButton: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Report Area',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MahallahPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Container(
                    width: 372,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment(-1, 3.13),
                        end: Alignment(0, 93.99),
                        colors: [
                          Color.fromRGBO(135, 203, 0, 0.70),
                          Color.fromRGBO(135, 203, 0, 0.35),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Mahallah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  KuliyyahPage()),
                );
                    // Add logic for Kulliyyah report
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Container(
                    width: 372,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment(-1, 3.13),
                        end: Alignment(0, 93.99),
                        colors: [
                          Color.fromRGBO(1, 169, 221, 0.70), // Updated color for Kulliyyah
                          Color.fromRGBO(1, 169, 221, 0.35), // Updated color for Kulliyyah
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Kulliyyah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>   FacilitiesPage()), // Assuming FacilitiesPage is the correct page
    );
  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Container(
                    width: 372,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment(-1, 3.13),
                        end: Alignment(0, 93.99),
                        colors: [
                          Color.fromRGBO(255, 212, 0, 0.70), // Updated color for Campus
                          Color.fromRGBO(255, 212, 0, 0.35), // Updated color for Campus
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Campus',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OtherPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Container(
                    width: 372,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment(-1, 3.13),
                        end: Alignment(0, 93.99),
                        colors: [
                         Color.fromRGBO(110, 103, 217, 0.70), // Updated color for Others
          Color.fromRGBO(110, 103, 217, 0.35), // Updated color for Others
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Other',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

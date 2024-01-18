import 'package:flutter/material.dart';
import 'BottomNavigationBarWidget.dart';
import 'LogoWidget.dart'; // Import your LogoWidget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _currentIndex = 3; // Set the current index for the Progress tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: LogoWidget(showBackButton: false),
      ),
      backgroundColor: const Color(0xFFFFFFF), // Set the background color to #E5E5E5
      body: const SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Progress Page',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Adjust text color
                  ),
                ),
                SizedBox(height: 32.0),
                // Fetch and display reports for each collection
                ReportDetailsWidget(collectionName: 'reportsMahallah'),
                ReportDetailsWidget(collectionName: 'reportsKulliyah'),
                ReportDetailsWidget(collectionName: 'reportsFacility'),
                ReportDetailsWidget(collectionName: 'reportsOther'),


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle navigation to other tabs if needed
        },
      ),
    );
  }
}

class ReportDetailsWidget extends StatefulWidget {
  final String collectionName;

  const ReportDetailsWidget({Key? key, required this.collectionName}) : super(key: key);

  @override
  _ReportDetailsWidgetState createState() => _ReportDetailsWidgetState();
}

class _ReportDetailsWidgetState extends State<ReportDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionName)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // Display the description, status, and icon for each report
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: snapshot.data?.docs.map((DocumentSnapshot document) {
            Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
            return _buildReportDetailsContainer(
              data?['description'] ?? '',
              data?['status'] ?? '',
              data?['time'] ?? Timestamp.now(),
            );
          }).toList() ?? [],
        );
      },
    );
  }

  Widget _buildReportDetailsContainer(String description, String status, Timestamp timestamp) {
    DateTime date = timestamp.toDate(); // Convert timestamp to DateTime

    // Define icons for each status
   Map<String, Map<String, dynamic>> statusDetails = {
  'Approved': {'icon': Icons.check, 'color': Colors.green},
  'Solved': {'icon': Icons.thumb_up, 'color': Colors.blue},
  'Declined': {'icon': Icons.do_not_disturb_outlined, 'color': Colors.red},
};


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                
                Row(
                  children: [
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                   Icon(
      statusDetails[status]?['icon'] ?? Icons.remove_red_eye_outlined,
      color: statusDetails[status]?['color'] ?? Colors.yellow[600],
    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:audit/Report_pages/ReportPageWidget.dart';
import 'package:flutter/material.dart';

class FacilitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReportPageWidget(
      pageTitle: 'Facilities Report',
      firstDropdownLabel: 'Facility',
      firstDropdownItems: [
        'Sultan Haji Ahmad Shah Mosque',
        'Cultural Centre (Business square)',
        'Student Mall (Kayros)',
        'Azman Hashim Complex (ATM Area)',
        'Library',
        'Sayyidina Hamzah Stadium',
        'Male complex center',
        'Female Complex Center',
        'Main Auditorium',
        'Mini Auditorium',
        'Experimental Hall',
        'Rectory Building',
        'IIUM Cultural Centre (ICC)',
        // Add more facility options as needed
      ],
      collectionName: 'reportsFacility',

    );
  }
}

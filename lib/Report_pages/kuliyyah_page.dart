import 'package:audit/Report_pages/ReportPageWidget.dart';
import 'package:flutter/material.dart';

class KuliyyahPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReportPageWidget(
      pageTitle: 'Kuliyyah Report',
      firstDropdownLabel: 'kulliyah',
      firstDropdownItems: [
        'Kulliyyah of Laws (AIKOL)',
        'Kulliyyah of Economics and Management Sciences (KENMS)',
        'Kulliyyah of Islamic Revealed Knowledge and Human Sciences (KIRKHS)',
        'Kulliyyah of Architecture and Environmental Design (KAED)',
        'Kulliyyah of Engineering (KOE)',
        'Kulliyyah of Education (KOE)',
        'Kulliyyah of Information and Communication Technology (KICT)',
        // Add more Kuliyyah options as needed
      ],
      collectionName: 'reportsKulliyah',

    );
  }
}

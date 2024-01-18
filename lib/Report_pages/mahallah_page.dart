import 'package:audit/BottomNavigationBarWidget.dart';
import 'package:audit/LogoWidget.dart';
import 'package:audit/signup%20pages/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:audit/home_page.dart';
class MahallahPage extends StatefulWidget {
  const MahallahPage({Key? key});

  @override
  _MahallahPageState createState() => _MahallahPageState();
}

class _MahallahPageState extends State<MahallahPage> {
  int _currentIndex = 2;

  String? _selectedMahallah;
  String? _selectedIssue;
  String? _selectedLocation;
  String _description = '';
  File? _selectedImage;
  String? _imageURL;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

Future<void> _submitReport() async {
  if (_selectedMahallah != null &&
      _selectedIssue != null &&
      _selectedLocation != null &&
      _description.isNotEmpty &&
      _selectedImage != null) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

    // Fetch user information from UserRepository
    Map<String, dynamic>? userInfo = await UserRepository().getUser(userId);
    String firstName = userInfo?['FirstName'] ?? '';
    String lastName = userInfo?['LastName'] ?? '';
    String matricNumber = userInfo?['matricNumber'] ?? '';

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child('reportsMahallah/$userId/$fileName.jpg');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');

    await storageReference.putFile(_selectedImage!, metadata);
    _imageURL = await storageReference.getDownloadURL();

    CollectionReference reports = FirebaseFirestore.instance.collection('reportsMahallah');
    await reports.add({
      'userId': userId,
      'userEmail': userEmail,
      'FirstName': firstName,
      'LastName': lastName,
      'matricNumber': matricNumber,
      'mahallah': _selectedMahallah,
      'issue': _selectedIssue,
      'specificLocation': _selectedLocation,
      'description': _description,
      'imageURL': _imageURL,
      'time': FieldValue.serverTimestamp(),
      'status': 'In progress',  // Set default status to 'In Progress'

    });

    _showSuccessDialog();
  } else {
    _showErrorDialog();
  }
}


  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Thank you! The report has been submitted.'),
              const SizedBox(height: 16.0),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Navigate to the home page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Your report is incomplete. Please fill in all fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LogoWidget(showBackButton: true),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '   Mahallah',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16.0),
                _buildDropdown('Mahallah', _selectedMahallah, _updateMahallah, 'Select a Mahallah'),
                const SizedBox(height: 16.0),
                _buildDropdown('Issue', _selectedIssue, _updateIssue, 'Select an Issue'),
                const SizedBox(height: 16.0),
                _buildTextField('Specific Location', _updateLocation, defaultText: 'Block / Level / Room'),
                const SizedBox(height: 16.0),
                _buildTextField('Description', _updateDescription, ),
                const SizedBox(height: 16.0),
                _buildImageSelectionButton(),
                const SizedBox(height: 16.0),
                _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        height: 100,
                      )
                    : Container(),
                const SizedBox(height: 16.0),
_buildElevatedButton('Submit Report', _submitReport, textColor: Colors.black),
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

 Widget _buildDropdown(String label, String? value, Function(String?) onChanged, String hint) {
  return Container(
    width: 345.0,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.grey),
      color: Colors.white,
    ),
    child: DropdownButtonFormField<String>(
      isDense: true,
      isExpanded: true, // Set to true to make the dropdown take up available horizontal space
      value: value,
      onChanged: (val) => onChanged(val),
      items: _getDropdownItems(label),
      decoration: InputDecoration.collapsed(
        hintText: hint,
      ),
      menuMaxHeight: 300.0, // Set the maximum height
    ),
  );
}


  List<DropdownMenuItem<String>> _getDropdownItems(String label) {
    if (label == 'Mahallah') {
      return [
        'MAHALLAH AL-FARUQ',
        'MAHALLAH AS-SIDDIQ',
        'MAHALLAH ALI IBN ABI TALIB',
        'MAHALLAH BILAL IBN RABAH',
        'MAHALLAH UTHMAN IBN AFFAN',
        'MAHALLAH ZUBAIR AL-AWWAM',
        'MAHALLAH SALAHUDDIN AL-AYYUBI',
        'MAHALLAH RUQAYYAH',
        'MAHALLAH AMINAH',
        'MAHALLAH ASIAH',
        'MAHALLAH ASMA',
        'MAHALLAH HAFSAH',
        'MAHALLAH HALIMATUS SAADIAH',
        'MAHALLAH MARYAM',
        'MAHALLAH NUSAIBAH',
        'MAHALLAH SAFIYYAH',
        'MAHALLAH SUMAYYAH',
      ].map<DropdownMenuItem<String>>(
        (value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      ).toList();
    } else if (label == 'Issue') {
      return [
        'Repair/ Maintenance',
        'Safety Hazard',
        'Infrastructure Upgrade',
        'Policy Violation',
        'Security/ Surveillance',
        'Accessibility',
        'Technology/ IT Support',
        'Cleanliness/ Sanitation',
        'Other'
      ].map<DropdownMenuItem<String>>(
        (value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      ).toList();
    } else {
      return [];
    }
  }

  Widget _buildTextField(String label, Function(String) onChanged, {int maxLines = 1, String? defaultText}) {
    return Container(
      width: 345.0,
      padding: const EdgeInsets.all(16.0),
     
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: TextFormField(
        onChanged: (val) => onChanged(val),
        maxLines: maxLines,
        decoration: InputDecoration.collapsed(hintText: defaultText ?? label),
      ),
    );
  }

  Widget _buildImageSelectionButton() {
    return GestureDetector(
      onTap: () {
        _showImageSourceDialog();
      },
      child: Container(
        width: 345.0,
        height: 55.0,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.attach_file),
                const SizedBox(width: 8.0),
                Text('Select Image'),
              ],
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildElevatedButton(String label, Function() onPressed, {Color? textColor}) {
  return Container(
    width: 345.0,
    height: 55.0,
    margin: const EdgeInsets.only(bottom: 16.0),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.yellow[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? Colors.black, // Set the default color to black if textColor is not provided
          fontSize: 18.0,
        ),
      ),
    ),
  );
}

  void _updateMahallah(String? value) {
    setState(() {
      _selectedMahallah = value;
    });
  }

  void _updateIssue(String? value) {
    setState(() {
      _selectedIssue = value;
    });
  }

  void _updateLocation(String value) {
    _selectedLocation = value;
  }

  void _updateDescription(String value) {
    _description = value;
  }
}
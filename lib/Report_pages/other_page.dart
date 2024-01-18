import 'dart:io';
import 'package:audit/BottomNavigationBarWidget.dart';
import 'package:audit/LogoWidget.dart';
import 'package:audit/signup%20pages/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audit/home_page.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({Key? key}) : super(key: key);

  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _selectedLocation;
  File? _selectedImage;
  String? _description;
  String? _selectedIssue;
  String? _userMatricNumber;
  String? _userFirstName;
  String? _userLastName;
  String? _userEmail;
  String? _selected_Location;

  List<String> selectedIssue = [
    'Repair/ Maintenance',
    'Safety Hazard',
    'Infrastructure Upgrade',
    'Policy Violation',
    'Security/ Surveillance',
    'Accessibility',
    'Technology/ IT Support',
    'Cleanliness/ Sanitation',
    'Other',
  ];

  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
    Map<String, dynamic>? userInfo = await UserRepository().getUser(userId);
    setState(() {
      _userMatricNumber = userInfo?['matricNumber'];
      _userFirstName = userInfo?['FirstName'];
      _userLastName = userInfo?['LastName'];
      _userEmail = FirebaseAuth.instance.currentUser?.email;
    });
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
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '   Other Page',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildDropdown('Select an Issue', _selectedIssue, _updateIssue),
              const SizedBox(height: 16.0),
              _buildGoogleMap(),
              const SizedBox(height: 16.0),
            ElevatedButton(
  onPressed: _getUserLocation,
  style: ElevatedButton.styleFrom(
    primary: Colors.yellow[600],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.location_on, // Use the location icon or any other icon you prefer
        color: Colors.black,
      ),
      SizedBox(width: 8.0), // Add some space between the icon and the text
      Text(
        'Get Current Location ',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
      ),
    ],
  ),
),

             const SizedBox(height: 16.0),
                _buildTextField('Specific Location', _updateLocation, defaultText: 'Specific Location'),
              const SizedBox(height: 16.0),
              _buildTextField('Description', _updateDescription),
               const SizedBox(height: 16.0),

              _buildImageSelectionButton(),
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 100.0,
                ),
              const SizedBox(height: 16.0),
              _buildElevatedButton('Submit Report', _submitLocation,textColor: Colors.black),
            ],
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

  Widget _buildDropdown(String label, String? value, Function(String?) onChanged) {
    return _buildContainer(
      child: DropdownButtonFormField<String>(
      isDense: true,
      isExpanded: true, // Set to true to make the dropdown take up available horizontal space
      value: value,
      onChanged: (val) => onChanged(val),
      items: _getDropdownItems(label),
      decoration: InputDecoration.collapsed(
        hintText: label,
      ),
      menuMaxHeight: 300.0, // Set the maximum height
    ),
    );
  }

  List<DropdownMenuItem<String>> _getDropdownItems(String label) {
    if (label == 'Select an Issue') {
      return selectedIssue
          .map<DropdownMenuItem<String>>(
            (value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList();
    } else {
      return [];
    }
  }

  Widget _buildGoogleMap() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey), // Adjust border color as needed
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
          onTap: _onMapTapped,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelectionButton() {
    return GestureDetector(
      onTap: () {
        _showImageSourceDialog();
      },
      child: _buildContainer(
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.attach_file),
                SizedBox(width: 8.0),
                Text('Select Image'),
              ],
            ),
          ],
        ),
      ),
    );
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

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: 345.0,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: child,
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
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

  void _onMapTapped(LatLng latLng) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('user_selected_location'),
          position: latLng,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      );
      _selectedLocation = latLng;
    });
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15.0,
          ),
        ),
      );

      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _updateDescription(String value) {
    _description = value;
  }

  Future<void> _submitLocation() async {
    if (_selectedLocation != null && _selectedIssue != null && _description != null && _selected_Location != null && _selectedImage!=null)  {
      try {
        // Upload image to Firebase Storage with metadata
        String userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance.ref().child('other_page/$userId/$fileName.jpg');

        // Set metadata with content type
        SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');

        // Upload the file with metadata
        await storageReference.putFile(_selectedImage!, metadata);

        // Get the download URL after uploading
        String imageURL = await storageReference.getDownloadURL();

        // Save location details in Cloud Firestore
        CollectionReference reports = FirebaseFirestore.instance.collection('reportsOther');
        reports.add({
          'userId': userId,
          'userEmail': _userEmail,
          'FirstName': _userFirstName,
          'LastName': _userLastName,
          'matricNumber': _userMatricNumber,
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
          'time': FieldValue.serverTimestamp(),
          'googleMapsLink': getGoogleMapsLink(_selectedLocation!.latitude, _selectedLocation!.longitude),
          'imageURL': imageURL, // Store the image URL
          'description': _description,
          'issue': _selectedIssue,
          'status': 'In progress', // Set default status to 'In Progress'
          'other' : 'other',
          'specificLocation': _selected_Location,

          

        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Report submitted'),
              content: const Text('report has been submitted sucssefully'),
              actions: [
                TextButton(
                  onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Navigate to the home page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error uploading image: $e');
        // Handle error if image upload fails
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill all files first'),
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
  }

  void _updateIssue(String? value) {
    setState(() {
      _selectedIssue = value;
    });
  }
  void _updateLocation(String value) {
    _selected_Location = value;
  }

  String getGoogleMapsLink(double latitude, double longitude) {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }
}

import 'dart:io';

import 'package:audit/EditPasswordPage.dart';
import 'package:audit/LogoWidget.dart';
import 'package:audit/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'signup pages/user_repository.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final UserRepository userRepository = UserRepository();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _matricNumberController = TextEditingController();
  String? _imageUrl;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      final user = await userRepository.getUser(uid);

      setState(() {
        _firstNameController.text = user?['FirstName'] ?? '';
        _lastNameController.text = user?['LastName'] ?? '';
        _matricNumberController.text = user?['matricNumber'] ?? '';
        _imageUrl = user?['imageUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final imageUrl = await userRepository.uploadImage(File(pickedFile.path));
        setState(() {
          _profileImage = File(pickedFile.path);
          _imageUrl = imageUrl;
        });
      } catch (error) {
        print('Error uploading image: $error');
        // Handle error as needed
      }
    }
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: _profileImage != null
                ? Image.file(_profileImage!, fit: BoxFit.cover)
                : (_imageUrl != null
                    ? Image.network(_imageUrl!, fit: BoxFit.cover)
                    : const Image(image: AssetImage('assets/profile.png'))),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.yellow[600],
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
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
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileImage(),
              const SizedBox(height: 50),
              buildTextField('First Name', Icons.person, _firstNameController),
              const SizedBox(height: 20),
              buildTextField('Last Name', Icons.person, _lastNameController),
              const SizedBox(height: 20),
              buildTextField('Matric Number', Icons.phone, _matricNumberController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Edit Profile functionality
                    updateProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to EditPasswordPage when Edit Password button is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditPasswordPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Edit Password',
                    style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, IconData prefixIcon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0), // Adjust the padding values
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  void updateProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final uid = currentUser.uid;

      // Get the current user information
      final user = await userRepository.getUser(uid);
      final String currentFirstName = user?['FirstName'] ?? '';
      final String currentLastName = user?['LastName'] ?? '';
      final String currentMatricNumber = user?['matricNumber'] ?? '';

      // Get the updated values from the controllers and image URL
      final String updatedFirstName = _firstNameController.text;
      final String updatedLastName = _lastNameController.text;
      final String updatedMatricNumber = _matricNumberController.text;

      // Check if the user has made any changes
      if (updatedFirstName == currentFirstName &&
          updatedLastName == currentLastName &&
          updatedMatricNumber == currentMatricNumber &&
          _imageUrl == user?['imageUrl']) {
        // No changes made, show a message to edit information
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please edit your information before saving.'),
            backgroundColor: Colors.red[400],
          ),
        );
      } else {
        // Changes made, update the user information in Firebase collection
        try {
          if (_profileImage != null) {
            // Update with image
            await userRepository.updateUserInfoWithImage(uid, updatedFirstName, updatedLastName, updatedMatricNumber, currentUser.email!, _imageUrl!);
          } else {
            // Update without image
            await userRepository.updateUser(uid, updatedFirstName, updatedLastName, updatedMatricNumber, currentUser.email!);
          }

          // Show a success message using SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to the ProfilePage using MaterialPageRoute
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        } catch (error) {
          // Handle errors, show error message, or perform other actions
          print('Error updating profile: $error');
        }
      }
    }
  }
}

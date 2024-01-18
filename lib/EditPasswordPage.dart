import 'package:audit/LogoWidget.dart';
import 'package:audit/ProfilePage.dart';
import 'package:audit/signup%20pages/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPasswordPage extends StatefulWidget {
  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final UserRepository userRepository = UserRepository();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool passwordUpdated = false;
  bool showCurrentPassword = false; // Initially do not show current password
  bool showNewPassword = false; // Initially do not show new password

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
              buildPasswordField('Current Password', _currentPasswordController, showCurrentPassword),
              const SizedBox(height: 20),
              buildPasswordField('New Password', _newPasswordController, showNewPassword),
              const SizedBox(height: 20),
              buildPasswordField('Confirm Password', _confirmPasswordController, showNewPassword),
              if (_newPasswordController.text != _confirmPasswordController.text)
                Text(
                  'New Password and Confirm Password do not match',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Handle Edit Password functionality
                    await updatePassword();
                    if (passwordUpdated) {
                      // Navigate to the ProfilePage only if the password is successfully updated
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    } else {
                      // Optionally, you can show an error message here if needed
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Save Password',
                    style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField(String labelText, TextEditingController controller, bool showPassword) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword, // Obfuscate text if showPassword is false
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              // Toggle the value to show/hide password
              if (labelText == 'Current Password') {
                showCurrentPassword = !showCurrentPassword;
              } else {
                showNewPassword = !showNewPassword;
              }
            });
          },
          child: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Future<void> updatePassword() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final String currentPassword = _currentPasswordController.text;
      final String newPassword = _newPasswordController.text;

      // Check if the new password is the same as the current password
      if (currentPassword == newPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New Password must be different from the Current Password'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Stop the function execution
      }

      try {
        // Reauthenticate the user with the current password
        final credential = EmailAuthProvider.credential(email: currentUser.email!, password: currentPassword);
        await currentUser.reauthenticateWithCredential(credential);

        // Check if new password and confirm password match
        if (newPassword == _confirmPasswordController.text) {
          // Update the password in Firebase authentication
          await userRepository.updatePassword(currentPassword, newPassword);

          // Set the flag to indicate that the password has been successfully updated
          passwordUpdated = true;

          // Show a success message using SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Show an error message if new password and confirm password do not match
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New Password and Confirm Password do not match'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        // Handle errors, show error message, or perform other actions
        print('Error updating password: $error');

        // Show an error message if reauthentication fails
        if (newPassword.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect current password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

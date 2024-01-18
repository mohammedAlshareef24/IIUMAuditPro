import 'package:flutter/material.dart';
import 'package:audit/LogoWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'BottomNavigationBarWidget.dart';
import 'UpdateProfilePage.dart';
import 'signup pages/user_repository.dart';
import 'signup pages/login_page.dart'; // Import the login page

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository userRepository = UserRepository();
  Map<String, dynamic>? userData;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController matricNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;

      try {
        final userSnapshot = await FirebaseFirestore.instance.collection('User Information').doc(uid).get();

        if (userSnapshot.exists) {
          final user = userSnapshot.data() as Map<String, dynamic>;

          setState(() {
            userData = user;
            // Set controller values
            firstNameController.text = user['FirstName'] ?? '';
            lastNameController.text = user['LastName'] ?? '';
            matricNumberController.text = user['matricNumber'] ?? '';
            emailController.text = user['email'] ?? '';
          });
        }
      } catch (error) {
        print('Error loading user data: $error');
      }
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log Out"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _logout(); // Call the logout method
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Log Out"),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await userRepository.signOut();
    // Navigate to the login page or any other page after logout
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LogoWidget(showBackButton: false),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: userData != null && userData!['imageUrl'] != null
                          ? Image.network(
                              userData!['imageUrl'],
                              fit: BoxFit.cover,
                            )
                          : const Image(image: AssetImage('assets/profile.png')),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                        );
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.yellow[600],
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${userData?['FirstName']} ${userData?['LastName']}' ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userData?['email'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              buildStyledTextField('First Name', userData?['FirstName'] ?? '', firstNameController),
              const SizedBox(height: 10),
              buildStyledTextField('Last Name', userData?['LastName'] ?? '', lastNameController),
              const SizedBox(height: 10),
              buildStyledTextField('Matric Number', userData?['matricNumber'] ?? '', matricNumberController),
              const SizedBox(height: 10),
              buildStyledTextField('Email', userData?['email'] ?? '', emailController),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _showLogoutConfirmationDialog, // Show confirmation dialog before logout
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }

  Widget buildStyledTextField(String labelText, String value, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.yellow),
            ),
          ),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

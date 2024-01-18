import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'login_page.dart'; // Import LoginPage
import 'user_repository.dart'; // Import UserRepository

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController matricNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String errorMessage = ''; // New variable to store an error message
    bool showPassword = false; // Initially do not show the password


  final UserRepository userRepository = UserRepository();

  // Function to validate form fields
  bool validateFields() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        matricNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all the fields.';
      });
      return false;
    } else if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match.';
      });
      return false;
    }
    return true;
  }

  Future<void> signUp() async {
  // Validate form fields
  if (!validateFields()) {
    // Show error dialog
    _showErrorDialog(errorMessage);
    return;
  }

  final String firstName = firstNameController.text;
  final String lastName = lastNameController.text;
  final String matricNumber = matricNumberController.text;
  final String email = emailController.text;
  final String password = passwordController.text;

  try {
    // Check if the matric number already exists in Firestore
    bool isMatricNumberTaken = await userRepository.isMatricNumberTaken(matricNumber);

    if (isMatricNumberTaken) {
      setState(() {
        errorMessage = 'Matric number is already in use. Please choose another one.';
      });
      _showErrorDialog(errorMessage);
      return;
    }

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      // Add user information to Firestore collection
      await userRepository.addUserInformation(
        userCredential.user!.uid,
        firstName,
        lastName,
        matricNumber,
        email,
        
      );

      // Navigate to the login page on successful signup
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()), // Navigate to LoginPage
      );
    } else {
      // Handle the case where user creation failed
      setState(() {
        errorMessage = 'User creation failed. Please try again.';
      });
      _showErrorDialog(errorMessage);
    }
  } catch (e) {
    // Handle any potential exceptions that may occur during signup
    print('Error: $e');
    setState(() {
      errorMessage = 'Error: $e';
    });
    _showErrorDialog(errorMessage);
  }
}

// Function to show an error dialog
void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 3,
                height: 335,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(335),
                  gradient: RadialGradient(
                    center: Alignment(0.5642, 0.394),
                    radius: 0.61,
                    colors: [Color(0xff87cb00), Color(0x7f87cb00)],
                    stops: [0.233, 1],
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Text(
                          'Create an Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      FadeInUp(
                        duration: Duration(milliseconds: 1210),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            controller: matricNumberController,
                            decoration: InputDecoration(
                              labelText: 'Matric Number',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      FadeInUp(
  duration: Duration(milliseconds: 1500),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: InputBorder.none,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              showPassword = !showPassword; // Toggle the value to show/hide password
            });
          },
          child: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
      obscureText: !showPassword,
    ),
  ),
),
const SizedBox(height: 16.0),
FadeInUp(
  duration: Duration(milliseconds: 1600),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: TextFormField(
      controller: confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: InputBorder.none,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              showPassword = !showPassword; // Toggle the value to show/hide password
            });
          },
          child: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
      obscureText: !showPassword,
    ),
  ),
),
                      const SizedBox(height: 24.0),
                      FadeInUp(
                        duration: Duration(milliseconds: 1700),
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: signUp,
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff518631),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login'); // Navigate to LoginPage
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xff518631),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

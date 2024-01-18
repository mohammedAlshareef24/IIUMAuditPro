import 'package:audit/signup%20pages/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_page.dart';
import 'package:animate_do/animate_do.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
    final UserRepository userRepository = UserRepository();


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

 Future<void> signInWithEmailAndPassword() async {
  final email = emailController.text;
  final password = passwordController.text;

  // Check if email or password is empty
  if (email.isEmpty || password.isEmpty) {
    _showErrorDialog('Please fill in both email and password.');
    return;
  }

  try {
    // Check if the email exists in the Firestore collection
    bool isEmailRegistered = await userRepository.isEmailRegistered(email);

    if (!isEmailRegistered) {
      _showErrorDialog('Email is not registered. Please sign up.');
      return;
    }

    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

      // Reset the error message when the login is successful
      setState(() {
        errorMessage = '';
      });
    } else {
      // Handle the case where authentication failed
      // You can display an error message or perform other actions
      setState(() {
        errorMessage = 'Authentication failed. Check your email and password.';
      });
      _showErrorDialog(errorMessage);
    }
  } catch (e) {
    // Handle any potential exceptions that may occur during authentication
    print('Error: $e');
    setState(() {
      errorMessage = 'Incorrect password. Please try again.';
    });
    _showErrorDialog(errorMessage);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 26,
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
                      duration: Duration(milliseconds: 1300),
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
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    FadeInUp(
                      duration: Duration(milliseconds: 1400),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: signInWithEmailAndPassword,
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff518631),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            'Login',
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
                      duration: Duration(milliseconds: 1500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgot_password');
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xff353d48),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    FadeInUp(
                      duration: Duration(milliseconds: 1600),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              'Sign Up',
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
    );
  }
}

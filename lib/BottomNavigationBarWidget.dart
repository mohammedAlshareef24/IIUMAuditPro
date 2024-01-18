import 'package:audit/ProfilePage.dart';
import 'package:audit/about_us_page.dart';
import 'package:audit/progress_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_page.dart'; // Import the home page

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GNav(
          backgroundColor: Colors.transparent,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Color.fromARGB(255, 132, 134, 132),
          gap: 8,
          padding: EdgeInsets.all(14),
          tabs: [
            GButton(
              icon: Icons.info_outline_rounded,
              text: 'About Us',
            ),
            GButton(
              icon: Icons.phone_in_talk,
              text: 'Emergency',
            ),
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.content_paste,
              text: 'Progress',
            ),
            GButton(
              icon: Icons.account_circle,
              text: 'Profile',
            ),
          ],
          selectedIndex: currentIndex,
          onTabChange: (index) {
            onTap(index);
            switch (index) {
              case 0:
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AboutUsPage()));
                break;
              case 1:
                Navigator.of(context).pushReplacementNamed('/emergency');
                break;
              case 2:
                // Use MaterialPageRoute to navigate to the home page
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                break;
              case 3:
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProgressPage()));
                break;
              case 4:
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage()));
                break;

            }
          },
        ),
      ),
    );
  }
}

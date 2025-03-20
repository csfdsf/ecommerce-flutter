import 'package:flutter/material.dart';
import 'package:interview_task/screens/cart_page.dart';
import 'package:interview_task/screens/product_page.dart';
import 'package:interview_task/screens/welcome_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.pinkAccent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.pinkAccent, size: 30),
                ),
                SizedBox(height: 10),
                Text("Welcome, User", style: TextStyle(fontSize: 18, color: Colors.white)),
                Text("user@example.com", style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.pinkAccent),
            title: Text("Home"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProductPage()), // ✅ Navigate to Welcome Screen
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.pinkAccent),
            title: Text("Cart"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CartPage()), // ✅ Navigate to Welcome Screen
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.pinkAccent),
            title: Text("Profile"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text("Logout"),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // ✅ Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout Confirmation"),
          content: Text("Are you sure you want to logout?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

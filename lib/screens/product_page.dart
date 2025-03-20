import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_page.dart';
import 'custom_drawer.dart';
import 'product_page_content.dart';
import 'welcome_screen.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedIndex = 0; // ✅ Default is Product Page

  final List<Widget> _pages = [
    ProductPageContent(), // ✅ Product Page Content (AppBar inside this widget)
    CartPage(), // ✅ Cart Page (Handles its own AppBar)
  ];

  void _onItemTapped(int index) {
    if (index == 2) { // ✅ If "Logout" is clicked, show confirmation dialog
      _showLogoutDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ✅ Prevents going back after logout
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        drawer: CustomDrawer(),
        appBar: _selectedIndex == 0
            ? AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello Zaskia",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
              Text("Jakarta, INA",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        )
            : null,

        body: _pages[_selectedIndex],

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.pinkAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
          ],
        ),
      ),
    );
  }


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
            // ❌ Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ✅ Close Dialog
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),

            // ✅ Confirm Logout Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ✅ Close Dialog
                _logoutUser(context); // ✅ Logout user
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _logoutUser(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()), // ✅ Navigate to Welcome Screen
      );


  }


}

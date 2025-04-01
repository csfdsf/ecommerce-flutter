import 'package:flutter/material.dart';
import 'package:interview_task/providers/cart_provider.dart';
import 'package:interview_task/screens/product_page.dart';
import 'package:provider/provider.dart';

class PaymentMethodPage extends StatefulWidget {
  final double totalAmount;

  PaymentMethodPage({required this.totalAmount});

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String selectedPaymentMethod = "Credit/Debit Card"; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Payment Method", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to Checkout Page
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Saved Cards Section
            Text("Saved Cards", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildSavedCards(),

            // 🔹 Other Payment Methods
            SizedBox(height: 20),
            Text("Other Ways To Pay", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            _buildPaymentOption("Credit/Debit Card", Icons.credit_card),
            _buildPaymentOption("Paypal", Icons.payment),
            _buildPaymentOption("Apple Pay", Icons.apple),
            _buildPaymentOption("Google Pay", Icons.account_balance_wallet),

            Spacer(),

            // 🔹 Amount to Pay
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount to Pay", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("\$${widget.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
            SizedBox(height: 20),

            // 🔹 Proceed to Pay Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent, // ✅ Button Color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                _processDummyPayment(context);
              },
              child: Center(
                child: Text("Proceed to Pay", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ✅ Saved Cards Carousel
  Widget _buildSavedCards() {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCard("HUSNAIN JALEEL", "**** **** **** 1234", "08/24"),
          _buildCard("John Doe", "**** **** **** 5678", "06/25"),
        ],
      ),
    );
  }

  // ✅ Card UI
  Widget _buildCard(String name, String number, String expiry) {
    return Container(
      width: 250,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.pink, Colors.pinkAccent]),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(number, style: TextStyle(fontSize: 16, color: Colors.white)),
          SizedBox(height: 5),
          Text("Valid Thru: $expiry", style: TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  // ✅ Payment Option
  Widget _buildPaymentOption(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: selectedPaymentMethod == title ? Colors.pinkAccent : Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: selectedPaymentMethod == title ? Colors.pinkAccent : Colors.black54),
            SizedBox(width: 10),
            Expanded(child: Text(title, style: TextStyle(fontSize: 16))),
            Icon(
              selectedPaymentMethod == title ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selectedPaymentMethod == title ? Colors.pinkAccent : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Dummy Payment Processing
  void _processDummyPayment(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Processing Payment..."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );

    // ✅ Simulate Payment Process
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context); // Close loading dialog
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment Successful!"),
          backgroundColor: Colors.pinkAccent,
        ),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductPage()));
    });
  }
}

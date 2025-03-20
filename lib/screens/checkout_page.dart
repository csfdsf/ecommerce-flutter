import 'package:flutter/material.dart';
import 'package:interview_task/screens/payment_method_page.dart';
import 'package:interview_task/screens/product_page.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Check out",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // ✅ Dismiss keyboard when tapping outside
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                //  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartProvider.cartItems.keys.elementAt(index);
                    final quantity = cartProvider.cartItems[product]!;
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.title,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text("Size - M",
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                                SizedBox(height: 5),
                                Text("\$${(product.price * quantity).toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),

                          // ✅ Quantity
                          Text("x$quantity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Discount code",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {},
                    child: Text("Apply", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 15),
              _buildSummaryRow("Subtotal", "\$${cartProvider.totalPrice.toStringAsFixed(2)}"),
              _buildSummaryRow("Shipping", "Enter shipping address", isShipping: true),
              _buildSummaryRow("Estimated Taxes", "\$12.00"),
              _buildSummaryRow("Others Fees", "\$0.00"),
              Divider(),
              _buildSummaryRow("Total", "USD \$${(cartProvider.totalPrice + 12.00).toStringAsFixed(2)}",
                  isBold: true),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.local_shipping_outlined, size: 18, color: Colors.grey),
                  SizedBox(width: 5),
                  Text("Free shipping to UK, US, BD, Canada", style: TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.refresh_outlined, size: 18, color: Colors.grey),
                  SizedBox(width: 5),
                  Text("Simple return and exchange process", style: TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                  SizedBox(width: 5),
                  Text("30 days return policy", style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPaymentButton("ShopPay", Colors.purple, Colors.white),
                  _buildPaymentButton("PayPal", Colors.yellow[700]!, Colors.black),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentMethodPage(totalAmount: cartProvider.totalPrice)),
                  );

                },
                child: Center(
                  child: Text("Others Pay", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isShipping = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          isShipping
              ? Text(value, style: TextStyle(fontSize: 14, color: Colors.grey))
              : Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        ),
      ),
    );
  }

  void _processDummyPayment(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing dialog manually
      builder: (context) {
        return AlertDialog(
          title: Text("Processing Payment..."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // ✅ Loading animation
              SizedBox(height: 10),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );

    // ✅ Simulate a delay to mimic real payment processing
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context); // ✅ Close loading dialog

      // ✅ Show Payment Successful Message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment Successful!"),
          backgroundColor: Colors.green,
        ),
      );

      // ✅ Navigate to Home Page after payment
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductPage()));
    });
  }
}

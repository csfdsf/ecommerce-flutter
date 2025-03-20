import 'package:flutter/material.dart';
import 'package:interview_task/screens/checkout_page.dart';
import 'package:interview_task/screens/product_page.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Cart",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProductPage()), // ✅ Redirect to Product Page
              );
              },
          ),
        ),
        body: cartProvider.cartItems.isEmpty
            ? Center(
          child: Text(
            "Your Cart is Empty",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
            : Column(
          children: [
            // ✅ Add spacing between AppBar & ListView
            SizedBox(height: 10), // Space below AppBar

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final productId = cartProvider.cartItems.keys.elementAt(index);
                  final product = cartProvider.cartItems.keys.elementAt(index);
                  final quantity = cartProvider.cartItems[product]!;

                  return Dismissible(
                    key: Key(product.title),
                    direction: DismissDirection.horizontal, // ✅ Swipe both ways
                    dismissThresholds: {DismissDirection.startToEnd: 0.2}, // ✅ Stops at 1/4th
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        return await _showDeleteConfirmation(context, product, cartProvider);
                      }
                      return false; // ✅ Do not delete on left swipe
                    },
                 //   background: _buildSwipeBackground(),
                    background: _buildDeleteBackground(),
                    child: _buildCartItem(product, quantity, cartProvider),
                  );

                },
              ),
            ),

            // ✅ Total Price & Checkout Button
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
              ),
              child: Column(
                children: [
                  // 🔹 Total Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 15),

                  // 🔹 Pay Now Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutPage()),
                      );
                    },
                    child: Text("Pay Now",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
      BuildContext context, Product product, CartProvider cartProvider) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Remove Item"),
        content: Text("Are you sure you want to remove ${product.title} from the cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel deletion
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              cartProvider.removeAllFromCart(product); // ✅ Remove item
              Navigator.of(context).pop(true);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  Widget _buildDeleteBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }

  // ✅ SWIPE RIGHT BACKGROUND (Optional Future Use)
  Widget _buildSwipeBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.edit, color: Colors.black54, size: 25),
    );
  }

  Widget _buildCartItem(Product product, int quantity, CartProvider cartProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.image,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Women Style", style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 5),
                Text("\$${(product.price * quantity).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.grey),
                onPressed: () {
                  cartProvider.removeFromCart(product);
                },
              ),
              Text("$quantity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.grey),
                onPressed: () {
                  cartProvider.addToCart(product);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

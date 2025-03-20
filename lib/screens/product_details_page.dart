import 'package:flutter/material.dart';
import 'package:interview_task/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import 'cart_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.network(
                      product.image,
                      width: screenWidth,
                      height: screenHeight * 0.60, // 45% of screen height
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                      Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.share, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.9,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis, // ✅ Prevents overflow
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "\$${product.price}",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Dagadu Jacket",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.justify, // ✅ Better text alignment
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              // Buy Now Button
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false).addToCart(product);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                  },
                  child: Text(
                    "Buy Now",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 15),
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 28,
                child: Icon(Icons.shopping_cart, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

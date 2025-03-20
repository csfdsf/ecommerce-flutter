import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_task/screens/product_details_page.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductPageContent extends StatefulWidget {
  @override
  _ProductPageContentState createState() => _ProductPageContentState();
}

class _ProductPageContentState extends State<ProductPageContent> {
  final ApiService apiService = ApiService();
  late Future<List<Product>> productList;

  @override
  void initState() {
    super.initState();
    productList = apiService.fetchProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height:10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: Icon(Icons.tune, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Big Sale",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Get trendy fashion at a discount of up to 50%",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.network(
                  "https://cdn-icons-png.flaticon.com/512/3081/3081974.png",
                  height: 70,
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching products'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products found'));
                } else {
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.7, // Adjust height ratio
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(product: product),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ❤️ Favorite Icon
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.favorite_border, color: Colors.grey),
                                ),
                              ),

                              // 🛍️ Product Image
                              Expanded(
                                child: Center(
                                  child: Image.network(
                                    product.image,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              // 📌 Product Name
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  product.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),

                              SizedBox(height: 5),

                              // 💰 Price & Discount
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "\$${product.price}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "\$${(product.price * 1.2).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 5),

                              // ⭐ Rating & Cart Button
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.orange, size: 16),
                                        Text(" 4k", style: TextStyle(fontSize: 12, color: Colors.black54)),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.shopping_cart, color: Colors.white, size: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

              }
              },
            ),
          ),
        ],
      ),
    );
  }
}

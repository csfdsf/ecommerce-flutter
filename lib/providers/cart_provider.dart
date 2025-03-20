import 'package:flutter/material.dart';
import 'package:interview_task/models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<Product, int> _cartItems = {}; // Stores product & quantity

  Map<Product, int> get cartItems => _cartItems;

  // ✅ Add product to cart or increase quantity
  void addToCart(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }
    notifyListeners();
  }

  // ✅ Remove product or decrease quantity
  void removeFromCart(Product product) {
    if (_cartItems.containsKey(product)) {
      if (_cartItems[product]! > 1) {
        _cartItems[product] = _cartItems[product]! - 1;
      } else {
        _cartItems.remove(product); // Remove item if quantity is 1
      }
    }
    notifyListeners();
  }

  void removeAllFromCart(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems.remove(product); // Removes the entire product entry
      notifyListeners();
    }
  }

  double get totalPrice {
    return _cartItems.entries.fold(0, (sum, entry) => sum + (entry.key.price * entry.value));
  }
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

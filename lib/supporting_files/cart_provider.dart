import 'package:flutter/material.dart';
import 'package:nowapps_round2/supporting_files/db_helper.dart';
import 'package:nowapps_round2/models/product_model.dart';

class CartProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();

  List<Product> cart = [];

  Future<List<Product>> getData() async {
    cart = await dbHelper.getCartProducts();

    notifyListeners();
    return cart;
  }

  void addProduct(int id) {
    final index = cart.indexWhere((element) => element.prodId == id);
    cart[index].quantity = cart[index].quantity + 1;
    notifyListeners();
  }

  void removeProduct(int id) {
    final index = cart.indexWhere((element) => element.prodId == id);
    cart[index].quantity = cart[index].quantity - 1;
    notifyListeners();
  }

  int getTotalQuantity() {
    int quantity = 0;
    for (Product p in cart) {
      quantity += p.quantity;
    }
    return quantity;
  }

  int getTotalAmount() {
    int sum = 0;
    for (Product p in cart) {
      sum += p.quantity * p.prodPrice;
    }
    return sum;
  }
}

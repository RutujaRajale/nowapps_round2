import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final int prodId;
  final String prodCode;
  final String prodName;
  final int prodPrice;
  final String prodImage;
  int quantity = 0;

  int getQuantity() {
    return quantity;
  }

  addProduct() {
    quantity = quantity + 1;
    notifyListeners();
  }

  Product(
      {required this.prodId,
      required this.prodCode,
      required this.prodName,
      required this.prodPrice,
      required this.prodImage});

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      prodId: json['prodId'],
      prodCode: json['prodCode'],
      prodName: json['prodName'],
      prodPrice: json['prodPrice'],
      prodImage: json['prodImage'],
    );
  }

  Map<String, dynamic> toMap() => {
        "prodId": prodId,
        "prodCode": prodCode,
        "prodName": prodName,
        "prodPrice": prodPrice,
        "prodImage": prodImage,
      };

  //getting data from API
  Future<Product> fetchProducts() async {
    final response = await http.get(Uri.parse('https://jsonkeeper.com/b/YIDG'));
    if (response.statusCode == 200) {
      return Product.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load product list');
    }
  }

  static List<Product> productsList = [
    Product(
        prodId: 1,
        prodCode: "8903287017032",
        prodName: "AIR, CONDITIONER IACS12AK3TC",
        prodPrice: 28500,
        prodImage:
            "https://www.daikinindia.com/sites/default/files/air-conditioners.png"),
    Product(
        prodId: 2,
        prodCode: "8903287028717",
        prodName: "SPLIT AC 1.5 T IAFS18XA3T3CA-IDU",
        prodPrice: 33690,
        prodImage:
            "https://www.daikinindia.com/sites/default/files/air-conditioners.png"),
    Product(
        prodId: 3,
        prodCode: "8903287000676",
        prodName: "TURBO DRY",
        prodPrice: 44610,
        prodImage:
            "https://catman-a2.infibeam.com/img/hoap/8841726/c9/29/sn26l200in.png.20c9296f29.999x435x515.jpg")
  ];
}

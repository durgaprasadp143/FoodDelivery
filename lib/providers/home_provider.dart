import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as root_bundle;
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/models/food_model.dart';

class HomeProvider extends ChangeNotifier {
  Foods foods = Foods();

  int carouselIndex = 0;

  List<Product> productList = [];

  String category = '';
  List categories = [
    "Fruits",
    "Vegetables",
    "Salad",
    "Grocery",
    "Dish",
    "Sweets",
    "Pizza"
  ];

  int qty = 1;

  int price = 0;

  int cutlery = 1;

  Cart cart = Cart([], 0);

  Future loadJson() async {
    final jsonData =
        await root_bundle.rootBundle.loadString("assets/json/food_items.json");
    final data = json.decode(jsonData) as Map<String, dynamic>;
    foods = Foods.fromJson(data);
    productList = foods.body?.products ?? [];
  }

  updateIndex(index) {
    carouselIndex = index;
    notifyListeners();
  }

  sort(text) {
    List<Product> temp = [];
    productList = foods.body?.products ?? [];
    if (text != '') {
      for (var element in productList) {
        if (element.category == text) {
          temp.add(element);
        }
      }
      productList = temp;
    }
    notifyListeners();
  }

  updateQty(value) {
    qty = value;
    price *= qty;
    notifyListeners();
  }

  updatePrice(value) {
    price = value;
    notifyListeners();
  }

  update(){
    notifyListeners();
  }
}

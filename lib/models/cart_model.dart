import 'package:food_delivery/models/food_model.dart';

class Cart {
  List<Item> items;
  int total;

  Cart(this.items, this.total);
}

class Item {
  Product product;
  int qty;

  Item(this.product, this.qty);
}

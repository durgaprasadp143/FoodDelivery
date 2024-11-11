import 'dart:convert';

Foods foodsFromJson(String str) => Foods.fromJson(json.decode(str));

String foodsToJson(Foods data) => json.encode(data.toJson());

class Foods {
  Body? body;

  Foods({
    this.body,
  });

  factory Foods.fromJson(Map<String, dynamic> json) => Foods(
    body: Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "body": body?.toJson(),
  };
}

class Body {
  List<Product> products;

  Body({
    required this.products,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  String productName;
  int productId;
  String image;
  int price;
  String category;
  Nutrients nutrients;
  String description;
  String type;

  Product({
    required this.productName,
    required this.productId,
    required this.image,
    required this.price,
    required this.category,
    required this.nutrients,
    required this.description,
    required this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productName: json["product_name"],
    productId: json["product_id"],
    image: json["image"],
    price: json["price"],
    category: json["category"],
    nutrients: Nutrients.fromJson(json["nutrients"]),
    description: json["description"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "product_id": productId,
    "image": image,
    "price": price,
    "category": category,
    "nutrients": nutrients.toJson(),
    "description": description,
    "type": type,
  };
}

class Nutrients {
  int kcal;
  int grams;
  int proteins;
  int fats;
  int carbs;

  Nutrients({
    required this.kcal,
    required this.grams,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });

  factory Nutrients.fromJson(Map<String, dynamic> json) => Nutrients(
    kcal: json["kcal"],
    grams: json["grams"],
    proteins: json["proteins"],
    fats: json["fats"],
    carbs: json["carbs"],
  );

  Map<String, dynamic> toJson() => {
    "kcal": kcal,
    "grams": grams,
    "proteins": proteins,
    "fats": fats,
    "carbs": carbs,
  };
}

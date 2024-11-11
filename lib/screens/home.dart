import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart' ;
import 'package:flutter/material.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/providers/home_provider.dart';
import 'package:food_delivery/widgets/custom_image.dart';
import 'package:provider/provider.dart';


class Home extends StatelessWidget {
  Home({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(context),
      body: FutureBuilder(future: Provider.of<HomeProvider>(context, listen: false).loadJson(), builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              appbar(context),
              const SizedBox(
                height: 30,
              ),
              hitsWeek(context),
              const SizedBox(
                height: 60,
              ),
              products(context),
            ],
          ),
          );
        }
        return const CircularProgressIndicator();
      },)
    );
  }

  Widget drawer(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: const Column(
        children: [
          Row(
            children: [
              Icon(Icons.home),
              SizedBox(
                width: 10,
              ),
              Text(
                "Home",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget appbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              size: 30,
            )),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: const Text(
            "100 St Road : 24 mins",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => cartPage(
                    context, Provider.of<HomeProvider>(context)),
              );
            },
            icon:  const Icon(
              Icons.shopping_cart_outlined,
              size: 30,
            )),
      ],
    );
  }

  Widget hitsWeek(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hits of the week",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        CarouselSlider(
          items: [
            Provider.of<HomeProvider>(context).foods.body?.products[22],
            Provider.of<HomeProvider>(context).foods.body?.products[25],
            Provider.of<HomeProvider>(context).foods.body?.products[24],
            Provider.of<HomeProvider>(context).foods.body?.products[27],
          ].map((e) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.pink.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.2, 1.2]),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              // padding: const EdgeInsets.symmetric(vertical: 8),
              margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                children: [
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, -20),
                      child: CustomImageView(
                        imgUrl: e?.image ?? '',
                        imgHeight: 150,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          e?.productName ?? '',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 20),
                          child: Text(
                            "\$ ${e?.price ?? 0} ",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              Provider.of<HomeProvider>(context, listen: false)
                  .updateIndex(index);
            },
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            enlargeCenterPage: false,
            padEnds: false,
            reverse: false,
            enableInfiniteScroll: true,
            viewportFraction: 1.0,
          ),
        ),
        Consumer<HomeProvider>(
          builder: (context, value, child) => Center(
            child: CarouselIndicator(
              height: 5,
              width: 70,
              color: Colors.grey,
              activeColor: Colors.black,
              count: 4,
              index: value.carouselIndex,
            ),
          ),
        )
      ],
    );
  }

  Widget products(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Provider.of<HomeProvider>(context, listen: false).sort('');
                  Provider.of<HomeProvider>(context, listen: false).category =
                      '';
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Provider.of<HomeProvider>(context, listen: false)
                                  .category ==
                              ''
                          ? Colors.red
                          : const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: const Icon(Icons.tune),
                ),
              ),
              Row(
                children: Provider.of<HomeProvider>(context)
                    .categories
                    .map((category) => categoryContainer(context, category))
                    .toList(),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Consumer<HomeProvider>(
          builder: (context, value, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: SingleChildScrollView(
                child: Column(
                  children: value.productList
                      .map((product) => GestureDetector(
                            onTap: () {
                              value.updatePrice(product.price);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    productPage(context, value, product),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomImageView(
                                      imgUrl: product.image,
                                      imgHeight: 100,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productName,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF1F1F1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 20),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                "\$ ${product.price}",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "${product.nutrients.kcal} kcal",
                                              style: const TextStyle(
                                                  color: Color(0xFFC2C2C2),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget nutrientVal(
    context,
    nutrientValue,
      nutrientLabel,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            nutrientValue,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            nutrientLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(

                color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget categoryContainer(
    context,
      category,
  ) {
    return GestureDetector(
      onTap: () {
        Provider.of<HomeProvider>(context, listen: false).sort(category);
        Provider.of<HomeProvider>(context, listen: false).category = category;
      },
      child: Container(
        decoration: BoxDecoration(
            color: Provider.of<HomeProvider>(context, listen: false).category ==
                category
                ? Colors.red
                : const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          category,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  Widget productPage(context, value, product) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: CustomImageView(
                  imgUrl: product.image,
                  imgHeight: 200,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 22),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          product.description,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 2, color: const Color(0xffF4F4F4))),
                          child: Row(
                            children: [
                              Expanded(
                                child: nutrientVal(
                                    context, product.nutrients.kcal.toString(), "kcal"),
                              ),
                              Expanded(
                                child: nutrientVal(
                                    context, product.nutrients.grams.toString(), "grams"),
                              ),
                              Expanded(
                                child: nutrientVal(
                                    context, product.nutrients.proteins.toString(), "proteins"),
                              ),
                              Expanded(
                                child: nutrientVal(
                                    context, product.nutrients.fats.toString(), "fats"),
                              ),
                              Expanded(
                                child: nutrientVal(
                                    context, product.nutrients.carbs.toString(), "carbs"),
                              ),
                            ],
                          ),
                                                 ),

                        const SizedBox(height: 20,),
                                         
                        Consumer<HomeProvider>(
                          builder:
                              (BuildContext context, HomeProvider value, Widget? child) {
                            return Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF1F1F1),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: value.qty > 1
                                              ? () {
                                                  value.updatePrice(product.price);
                                                  value.updateQty(value.qty -= 1);
                                                }
                                              : null,
                                          icon: const Icon(Icons.horizontal_rule)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: Text(
                                          value.qty.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            value.updatePrice(product.price);
                                            value.updateQty(value.qty += 1);
                                          },
                                          icon: const Icon(Icons.add))
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    final index = value.cart.items.indexWhere((item) => item.product == product);
                        
                                    if (index != -1) {
                                      value.cart.items[index].qty += value.qty;
                                    }
                                    else {
                                      value.cart.items.add(Item(product, value.qty));
                                    }
                                    int price = 0;
                                    for (var element in value.cart.items) {
                                      price += element.product.price * element.qty;
                                    }
                                    value.cart.total = price;
                                    Navigator.of(context).pop();
                                    value.qty = 1;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      backgroundColor: Colors.black,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                      content: GestureDetector(
                                        onTap: () {},
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Cart",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "24 min",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(50)),
                                                  width: 5,
                                                  height: 5,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "\$ ${Provider.of<HomeProvider>(context, listen: false).cart.total}",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Text(
                                      "Add to Cart     \$${value.price} ",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
           
          ],
        ));
  }

  Widget cartPage(context, value) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We will deliver in \n24 min to this address:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 32),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Text(
                  '100 St Road',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Change address',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 200,
              child: Consumer<HomeProvider>(
                builder: (context, value, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.cart.items.length,
                    itemBuilder: (context, index) {
                      var e = value.cart.items;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomImageView(
                                imgUrl: e[index].product.image,
                                imgHeight: 75,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e[index].product.productName,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF1F1F1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: IconButton(
                                            onPressed: e[index].qty > 1
                                                ? () {
                                                    e[index].qty -= 1;
                                                    int price = 0;
                                                    for (var element
                                                        in value.cart.items) {
                                                      price += element
                                                              .product.price *
                                                          element.qty;
                                                    }
                                                    value.cart.total = price;
                                                    value.update();
                                                  }
                                                : null,
                                            icon: const Icon(
                                                Icons.horizontal_rule)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          e[index].qty.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF1F1F1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: IconButton(
                                            onPressed: () {
                                              e[index].qty += 1;
                                              int price = 0;
                                              for (var element
                                                  in value.cart.items) {
                                                price += element.product.price *
                                                    element.qty;
                                              }
                                              value.cart.total = price;
                                              value.update();
                                            },
                                            icon: const Icon(Icons.add)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "\$ ${e[index].product.price * e[index].qty}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cutlery",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 22),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                          onPressed: value.cutlery > 1
                              ? () {
                                  value.cutlery -= 1;
                                  value.update();
                                }
                              : null,
                          icon: const Icon(Icons.horizontal_rule)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        value.cutlery.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 22),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                          onPressed: () {
                            value.cutlery += 1;
                            value.update();
                          },
                          icon: const Icon(Icons.add)),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Free Delivery",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ],
                ),
                Text(
                  "\$0",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 22),
                ),
              ],
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Method",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    Text(
                      "Apple Pay",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<HomeProvider>(
              builder:
                  (BuildContext context, HomeProvider value, Widget? child) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pay",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "24 min",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              width: 5,
                              height: 5,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "\$ ${Provider.of<HomeProvider>(context, listen: false).cart.total}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ));
  }
}

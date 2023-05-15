import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantapplication/screens/dishes.dart';
import 'package:restaurantapplication/widgets/grid_product.dart';
import 'package:restaurantapplication/widgets/home_category.dart';
import 'package:restaurantapplication/widgets/slider_item.dart';
import 'package:restaurantapplication/util/foods.dart';
import 'package:restaurantapplication/util/categories.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'login_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  final User user;

  Home({required this.user});
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Dishes",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return DishesScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 10.0),
// for qr code
            // QrScannerCamera(
            //   onError: (context, error) => Text(
            //     error.toString(),
            //     style: TextStyle(color: Colors.red),
            //   ),
            //   qrCodeCallback: (code) {
            //     print(code);
            //   },
            // ),
            //Slider Here

            CarouselSlider(
              // height: MediaQuery.of(context).size.height / 2.4,
              items: map<Widget>(
                foods,
                (index, i) {
                  Map food = foods[index];
                  return SliderItem(
                    img: food['img'],
                    isFav: false,
                    name: food['name'],
                    rating: 5.0,
                    raters: 23,
                  );
                },
              ).toList(),

//                enlargeCenterPage: true,
//              aspectRatio: 2.0,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 2.4,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                // onPageChanged: (index) {
                //           setState(() {
                //             _current = index;
                //           });
                //         },
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 20.0),

            const Text(
              "Food Categories",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10.0),

            Container(
              height: 65.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories == null ? 0 : categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];
                  return HomeCategory(
                    icon: cat['icon'],
                    title: cat['name'],
                    items: cat['items'].toString(),
                    isHome: true,
                  );
                },
              ),
            ),

            const SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Popular Items",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: foods == null ? 0 : foods.length,
              itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
                Map food = foods[index];
//                print(foods);
//                print(foods.length);
                return GridProduct(
                  img: food['img'],
                  isFav: false,
                  name: food['name'],
                  rating: 5.0,
                  raters: 23,
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

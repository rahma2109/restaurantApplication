import 'package:flutter/material.dart';
import 'package:restaurantapplication/screens/checkout.dart';
import 'package:restaurantapplication/util/foods.dart';
import 'package:restaurantapplication/widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin<CartScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView.builder(
          itemCount: foods == null ? 0 : foods.length,
          itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
            Map food = foods[index];
//                print(foods);
//                print(foods.length);
            return CartItem(
              img: food['img'],
              isFav: false,
              name: food['name'],
              rating: 5.0,
              raters: 23,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Checkout",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Checkout();
              },
            ),
          );
        },
        heroTag: Object(),
        child: const Icon(
          Icons.arrow_forward,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:nowapps_round2/models/product_model.dart';
import 'package:nowapps_round2/screens/cart_page.dart';
import 'package:nowapps_round2/supporting_files/cart_provider.dart';
import 'package:nowapps_round2/global_variables.dart';
import 'package:nowapps_round2/widgets/plus_minus_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RetailerPage extends StatefulWidget {
  RetailerPage({Key? key}) : super(key: key);
  TextEditingController noOrderReasonController = TextEditingController();
  @override
  State<RetailerPage> createState() => _RetailerPageState();
}

class _RetailerPageState extends State<RetailerPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (prefs.hasData) {
            String retailerName =
                prefs.data?.getString('checkIn') ?? "not selected";

            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 235, 239, 243),
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: SizedBox(
                    height: 50,
                    child: Image.network(GlobalVariables
                        .retailerDetails[retailerName]["shopImage"]),
                  ),
                  actions: [
                    Consumer<CartProvider>(
                        builder: (context, provider, widget) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20.0, top: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartPage()));
                          },
                          child: Badge(
                            badgeColor:
                                const Color.fromARGB(255, 161, 211, 237),
                            badgeContent:
                                Text(provider.getTotalQuantity().toString()),
                            child: const Icon(Icons.shopping_cart),
                          ),
                        ),
                      );
                    })
                  ]),
              body: _buildBody(context, retailerName),
            );
          } else {
            return const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildBody(BuildContext context, String retailerName) {
    return Consumer<CartProvider>(
      builder: (context, provider, widget) {
        if (provider.cart.isEmpty) {
          return Center(
              child: Column(
            children: [
              const Text(
                'There are no products to display',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: const Text('Exit'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
              ),
            ],
          ));
        } else {
          return Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.cart.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child:
                                  Image.network(provider.cart[index].prodImage),
                            ),
                            SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    text: TextSpan(
                                      text:
                                          '${provider.cart[index].prodName}\n',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade800,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: 'Code: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 12.0),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${provider.cart[index].prodCode}\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                  RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: 'Price: Rs.',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 16.0),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${provider.cart[index].prodPrice}\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            if (provider.cart[index].quantity > 0)
                              PlusMinusButtons(
                                addQuantity: () {
                                  provider
                                      .addProduct(provider.cart[index].prodId);
                                },
                                deleteQuantity: () {
                                  provider.removeProduct(
                                      provider.cart[index].prodId);
                                },
                                text: provider.cart[index].quantity.toString(),
                              ),
                            if (provider.cart[index].quantity == 0)
                              addToCartButton(provider.cart[index], provider),
                          ],
                        ),
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: const Text('Proceed to checkout'),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartPage()));
                      },
                    )),
              )
            ],
          );
        }
      },
    );
  }

  addToCartButton(Product product, CartProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
            ),
            child: const Text('Add to cart'),
            onPressed: () async {
              provider.addProduct(product.prodId);
            },
          )),
    );
  }
}

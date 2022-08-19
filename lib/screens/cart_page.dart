import 'package:flutter/material.dart';
import 'package:nowapps_round2/supporting_files/cart_provider.dart';
import 'package:nowapps_round2/global_variables.dart';
import 'package:nowapps_round2/widgets/plus_minus_widget.dart';
import 'package:nowapps_round2/widgets/total_row_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);
  TextEditingController noOrderReasonController = TextEditingController();
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
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
                automaticallyImplyLeading: true,
                title: SizedBox(
                  height: 50,
                  child: Image.network(GlobalVariables
                      .retailerDetails[retailerName]["shopImage"]),
                ),
              ),
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
    TextEditingController _textFieldController = TextEditingController();
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
                    if (provider.cart[index].quantity > 0) {
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
                                child: Image.network(
                                    provider.cart[index].prodImage),
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
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
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
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              Consumer<CartProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  final ValueNotifier<int?> totalPrice = ValueNotifier(null);
                  final ValueNotifier<int?> totalQuantity = ValueNotifier(null);
                  for (var element in value.cart) {
                    totalQuantity.value =
                        (element.quantity) + (totalPrice.value ?? 0);
                    totalPrice.value = (element.prodPrice * element.quantity) +
                        (totalPrice.value ?? 0);
                  }
                  return Column(
                    children: [
                      if (totalQuantity.value == 0)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: Text('No item added to cart'),
                        ),
                      ValueListenableBuilder<int?>(
                          valueListenable: totalPrice,
                          builder: (context, val, child) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                color: const Color.fromARGB(25, 9, 9, 9),
                                child: TotalRowWidget(
                                    title: 'Total Amount',
                                    value: 'Rs. ' +
                                        (val?.toStringAsFixed(2) ?? '0')),
                              ),
                            );
                          }),
                      ValueListenableBuilder<int?>(
                          valueListenable: totalQuantity,
                          builder: (context, val, child) {
                            return totalQuantity.value! > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue,
                                          ),
                                          child: const Text(
                                              'Place Order & Checkout'),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Order placed and checked out of " +
                                                      retailerName),
                                            ));
                                            prefs.remove('checkIn');

                                            Navigator.pop(context);
                                          },
                                        )),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue,
                                          ),
                                          child: const Text(
                                              'Checkout without Order',
                                              style: TextStyle(fontSize: 18.0)),
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Reason for No Order'),
                                                    content: TextField(
                                                      onChanged: (value) {},
                                                      controller:
                                                          _textFieldController,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Please enter reason here"),
                                                    ),
                                                    actions: <Widget>[
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: ElevatedButton(
                                                          child: const Text(
                                                              'Submit and Checkout'),
                                                          onPressed: () async {
                                                            if (_textFieldController
                                                                .text
                                                                .isNotEmpty) {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                    "Reason submitted and checked out of " +
                                                                        retailerName),
                                                              ));
                                                              prefs.remove(
                                                                  'checkIn');

                                                              int count = 0;
                                                              Navigator
                                                                  .popUntil(
                                                                      context,
                                                                      (route) {
                                                                return count++ ==
                                                                    2;
                                                              });
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                content: Text(
                                                                    "Please enter a reason to submit"),
                                                              ));
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        )),
                                  );
                          }),
                    ],
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }
}

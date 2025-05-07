import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_bani/service/database.dart';
import 'package:shop_bani/service/shared_pref.dart';
import 'package:shop_bani/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id;
  int total = 0;

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      setState(() {});
    });
  }

  clearCart() async {
    if (id == null) return;

    // 🔁 Clear cart items
    QuerySnapshot cartSnapshot =
        await FirebaseFirestore.instance
            .collection("Cart")
            .doc(id)
            .collection("Items")
            .get();

    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    // ✅ Wait for deletion to complete and then re-fetch the stream
    await Future.delayed(Duration(milliseconds: 300));

    // 🔄 Re-fetch the cart items and update stream
    CartItemsStream =
        FirebaseFirestore.instance
            .collection("Cart")
            .doc(id)
            .collection("Items")
            .snapshots();

    // ✅ Force UI rebuild and reset total price
    setState(() {
      total = 0;
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserID();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    CartItemsStream = await DatabaseMethods().getCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Stream? CartItemsStream;

  Widget Cart() {
    return StreamBuilder(
      stream: CartItemsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.hasData) {
          total = 0; // Reset total before starting

          if (snapshot.data.docs.isEmpty) {
            return Center(child: Text("Your cart is empty."));
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              total += int.parse(ds["Total"]); // Clean syntax

              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 30,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(ds["Quantity"])),
                        ),
                        SizedBox(width: 20.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            ds["Image"],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          children: [
                            Text(
                              ds["Name"],
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                            Text(
                              "Tk." + ds["Total"],
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text("Your cart is empty."));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 191, 145),
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text(
                    "Cart",
                    style: AppWidget.headlineTextFeildStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Cart(),
            ),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price", style: AppWidget.boldTextFeildStyle()),
                  Text("Tk.$total", style: AppWidget.semiBoldTextFeildStyle()),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                await clearCart();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("🎉 Congrats on your product purchase!"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

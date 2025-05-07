import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_bani/pages/details.dart';
import 'package:shop_bani/service/database.dart';
import 'package:shop_bani/widget/widget_support.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool bags = false, perfumes = false, glasses = false, pouch = false;

  Stream? ItemsStream;

  ontheload() async {
    ItemsStream = await DatabaseMethods().getItems("Bags");
    setState(() {
      bags = true;
    });
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 191, 191),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Samiha", style: AppWidget.boldTextFeildStyle()),
                  Container(
                    margin: EdgeInsets.only(right: 30.0),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 199, 97, 143),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.girl_outlined, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "The Best Place for Girlies in Town!",
                style: AppWidget.lightTextFeildStyle(),
              ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: showItem(),
              ),
              SizedBox(height: 30.0),
              SizedBox(height: 270, child: allItemshorizontally()),
              allItemsVertically(),
            ],
          ),
        ),
      ),
    );
  }

  // For horizontal viewing of items
  Widget allItemshorizontally() {
    return StreamBuilder(
      stream: ItemsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Details(
                              detail: ds["detail"],
                              name: ds["name"],
                              price: ds["price"],
                              image: ds["image"],
                            ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(3.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                ds["image"],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              ds["name"],
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              ds["detail"],
                              style: AppWidget.lightTextFeildStyle(),
                            ),
                            Text(
                              "Tk." + ds["price"],
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
            : CircularProgressIndicator();
      },
    );
  }

  Widget allItemsVertically() {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: ItemsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Details(
                                detail: ds["detail"],
                                name: ds["name"],
                                price: ds["price"],
                                image: ds["image"],
                              ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0, right: 20.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  ds["image"],
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      ds["name"],
                                      style: AppWidget.semiBoldTextFeildStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      ds["detail"],
                                      style: AppWidget.lightTextFeildStyle(),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      "TK. " + ds["price"],
                                      style: AppWidget.semiBoldTextFeildStyle(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
              : CircularProgressIndicator();
        },
      ),
    );
  }

  Widget showItem() {
    return //////////Categories of Products
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///////////////Category-1 Bags
        GestureDetector(
          onTap: () async {
            bags = true;
            perfumes = glasses = pouch = false;
            ItemsStream = await DatabaseMethods().getItems("Bags");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: bags ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/bags.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: bags ? Colors.white : null,
              ),
            ),
          ),
        ),
        ///////////////Category-2 perfumes
        GestureDetector(
          onTap: () async {
            perfumes = true;
            bags = glasses = pouch = false;
            ItemsStream = await DatabaseMethods().getItems("Perfumes");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: perfumes ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/perfumes.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: perfumes ? Colors.white : null,
              ),
            ),
          ),
        ),
        ///////////////Category-3 glasses
        GestureDetector(
          onTap: () async {
            glasses = true;
            perfumes = bags = pouch = false;
            ItemsStream = await DatabaseMethods().getItems("Glasses");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: glasses ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/glasses.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: glasses ? Colors.white : null,
              ),
            ),
          ),
        ),
        ///////////////Category-4 Pouches
        GestureDetector(
          onTap: () async {
            pouch = true;
            perfumes = glasses = bags = false;
            ItemsStream = await DatabaseMethods().getItems("Pouch");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: pouch ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/pouch.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: pouch ? Colors.white : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

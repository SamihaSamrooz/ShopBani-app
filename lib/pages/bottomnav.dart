import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shop_bani/pages/home.dart';
import 'package:shop_bani/pages/order.dart';
import 'package:shop_bani/pages/profile.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Order order;

  @override
  void initState() {
    super.initState();
    homepage = Home();
    order = Order();
    profile = Profile();
    pages = [homepage, order, profile];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 45,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_outlined, color: Color.fromARGB(255, 222, 136, 136)),
          Icon(
            Icons.shopping_bag_outlined,
            color: Color.fromARGB(255, 222, 136, 136),
          ),
          Icon(Icons.person_outline, color: Color.fromARGB(255, 222, 136, 136)),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}

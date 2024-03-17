import 'package:flutter/material.dart';
import 'package:fresh_find_vendor/views/earning/earning_view.dart';
import 'package:fresh_find_vendor/views/orders/order_view.dart';
import 'package:fresh_find_vendor/views/product_list/product_list_view.dart';
import 'package:fresh_find_vendor/views/profile/profile_view.dart';

import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    Text('Products'),
    Text('Orders'),
    Text('Profile'),
    Text('Logout'),
  ];

  final List<Widget> _widgetPages = [
    ItemListView(),
    OrderView(),
    ProfileView()
  ];

  Future<void> _onItemTapped(int index) async {
    if (index == _widgetOptions.length - 1) {
      await FirebaseService().logout();
      Navigator.pushNamedAndRemoveUntil(
          context, AppConstant.loginView, (route) => false);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _widgetOptions[_selectedIndex],
      ),
      body: _widgetPages.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.green,
        indicatorColor: Colors.greenAccent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Products',
            selectedIcon: Icon(Icons.shopping_bag),
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
            selectedIcon: Icon(Icons.receipt_long),
          ),
        /*  NavigationDestination(
            icon: Icon(Icons.attach_money_outlined),
            label: 'Earning',
            selectedIcon: Icon(Icons.attach_money),
          ),*/
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            selectedIcon: Icon(Icons.person),
          ),
          NavigationDestination(
            icon: Icon(Icons.logout_outlined),
            label: 'Logout',
            selectedIcon: Icon(Icons.logout),
          ),
        ],
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../model/item.dart';
import 'components/item_form.dart';



class ItemView extends StatelessWidget {

  Item? item;


  ItemView({this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Item',
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ItemForm(item: item,),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';


import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';
import '../../model/item.dart';

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  Future<void> _showDeleteDialog(Item item, BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (res) {
      await FirebaseService().deleteItem(item.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: StreamBuilder<List<Item>>(
            stream: FirebaseService().itemStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                      color: Colors.redAccent,
                    ));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Item item = snapshot.data![index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            isThreeLine: true,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppConstant.productView,
                                  arguments: snapshot.data![index]);
                            },
                            leading: Image.network(item.imageUrl, width: 80, height: 80,),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 24,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(item.description),
                                Text('Price : ${item.price} /${item.unit}'),
                                Text('Stock : ${item.stock} ${item.unit}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _showDeleteDialog(
                                        snapshot.data![index], context);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                            /*trailing: IconButton(
                              onPressed: () {
                                */ /*_showDeleteDialog(
                                    snapshot.data![index], context);*/ /*
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.grey.shade400,
                              ),
                            ),*/
                            /*isThreeLine: true,*/
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(child: Text('No categories found'));
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstant.productView);
        },
        backgroundColor: Colors.green.shade100,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

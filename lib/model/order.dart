
import 'package:fresh_find_vendor/model/address.dart';
import 'package:fresh_find_vendor/model/cart.dart';

class Order {
  String? orderId;
  String? userId;
  int? orderDate;
  List<Cart>? items;
  String? paymentId;
  double? totalPrice;
  String? status;
  Address? shippingAddress;

  Order(
      {this.orderId,
        this.userId,
        this.orderDate,
        this.items,
        this.paymentId,
        this.totalPrice,
        this.status,
        this.shippingAddress});

  Map<dynamic, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "orderDate": orderDate,
      "items": items?.map((item) => item.toJson()).toList(),
      "paymentId": paymentId,
      "status": status,
      "shippingAddress": shippingAddress?.toJson(),
    };
  }

  static Order fromJson(Map<dynamic, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      userId: json['userId'],
      orderDate: json['orderDate'],
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => Cart.fromJson(item))
          .toList(),
      paymentId: json['paymentId'],
      status: json['status'],
      shippingAddress: json['shippingAddress'] != null
          ? Address.fromJson(json['shippingAddress'])
          : null,
    );
  }

}

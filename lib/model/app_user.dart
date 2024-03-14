class AppUser {
  String? id;
  String email;
  String password;
  String vendorName;
  String businessName;
  String contactNumber;
  String address;
  String state;
  String city;
  int createdAt = DateTime.now().millisecondsSinceEpoch;

  AppUser(
      {this.id,
      required this.email,
      required this.password,
      required this.vendorName,
      required this.businessName,
      required this.contactNumber,
      required this.address,
      required this.state,
      required this.city});

  factory AppUser.fromJson(Map<dynamic, dynamic> json) {
    return AppUser(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      vendorName: json["vendorName"],
      businessName: json["businessName"],
      contactNumber: json["contactNumber"],
      address: json["address"],
      state: json["state"],
      city: json["city"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "email": this.email,
      "password": this.password,
      "vendorName": this.vendorName,
      "businessName": this.businessName,
      "contactNumber": this.contactNumber,
      "address": this.address,
      "state": this.state,
      "city": this.city,
      "createdAt": this.createdAt,
    };
  }
}

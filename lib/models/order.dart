import 'package:streambox/config/enumvals.dart';

class Order {
  String orderID;
  String contact;
  String orderDate;
  String customerName;
  String customerID;
  String customerAddress;
  // farm attributes for distributor ordering
  String farmOwner;
  String farmName;
  String farmContact;
  String farmAddress;
  String lga;
  OrderStatus status;
  Map<String, Map<String, int>> products;
  int productCount;
  int cratesOfEggs;
  int chickenCount;
  double crateOfEggUnitPrice;
  double chickenUnitPrice;
  double totalPrice;

  Order({
    this.orderID,
    this.contact,
    this.customerAddress,
    this.customerID,
    this.customerName,
    this.orderDate,
    this.productCount,
    this.products,
    this.status,
    this.cratesOfEggs = 0,
    this.chickenCount = 0,
    this.chickenUnitPrice = 0,
    this.crateOfEggUnitPrice = 0,
    this.totalPrice = 0,
    this.farmOwner,
    this.farmName,
    this.farmAddress,
    this.farmContact,
    this.lga,
  });
}

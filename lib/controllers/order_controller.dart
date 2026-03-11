import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class OrderController extends GetxController {
  RxList<Orderr> orders = <Orderr>[].obs;

  void loadOrders(String tailorId) {
    FirebaseFirestore.instance
        .collection('orders')
        .where('expectedTailorId', isEqualTo: tailorId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
          orders.assignAll(
            snapshot.docs.map((doc) {
              Orderr order = Orderr.fromDocument(doc);
              return order;
            }),
          );
        });
  }

  void acceptOrder(String tailorId, Orderr order) async {
    String orderId = order.getDocumentId() ?? '';

    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'TailorId': tailorId,
      'status': "Running",
    });

    // Remove the accepted order directly
    orders.removeWhere((order) => order.tailorId == order.expId);
  }
}

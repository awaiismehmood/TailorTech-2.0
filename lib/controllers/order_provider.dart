import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersStreamProvider = StreamProvider.family<List<Orderr>, String>((ref, tailorId) {
  return FirebaseFirestore.instance
      .collection('orders')
      .where('expectedTailorId', isEqualTo: tailorId)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Orderr.fromDocument(doc)).toList();
  });
});

final orderActionsProvider = Provider((ref) => OrderActions());

class OrderActions {
  Future<void> acceptOrder(String tailorId, Orderr order) async {
    String orderId = order.getDocumentId() ?? '';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'TailorId': tailorId,
      'status': "Running",
    });
  }
}

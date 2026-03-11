import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/consts/consts.dart';

Future<List<Map<String, dynamic>>> retrieveLocationData() async {
  List<Map<String, dynamic>> locationDataList = [];

  try {
    // Reference to the 'tailor' collection
    CollectionReference tailorCollection =
        FirebaseFirestore.instance.collection(usersCollection1);

    // Get documents from the 'tailor' collection
    QuerySnapshot tailorSnapshot = await tailorCollection.get();

    // Iterate through the documents
    for (QueryDocumentSnapshot document in tailorSnapshot.docs) {
      // Access the document ID
      String documentId = document.id;

      // Access the latitude and longitude
      double latitude = document['latitude'];
      double longitude = document['longitude'];

      // Create a map for the current document
      Map<String, dynamic> locationData = {
        'documentId': documentId,
        'latitude': latitude,
        'longitude': longitude,
      };

      // Add the map to the list
      locationDataList.add(locationData);
    }

    // Return the list of maps
    return locationDataList;
  } catch (e) {
    print('Error retrieving location data: $e');
    // You might want to handle the error or return an empty list depending on your use case
    return [];
  }
}

// Future<List<double>> retrieveAllLongitudes() async {
//   // Reference to the Firestore collection named 'tailor'
//   CollectionReference tailorCollection =
//       FirebaseFirestore.instance.collection(usersCollection1);

//   List<double> Logitudes = [];

//   try {
//     // Get all documents in the 'tailor' collection
//     QuerySnapshot querySnapshot = await tailorCollection.get();

//     // Iterate through the documents and retrieve the 'location' field
//     for (QueryDocumentSnapshot document in querySnapshot.docs) {
//       // Check if the document exists and data is not null
//       if (document.exists && document.data() != null) {
//         // Explicitly cast data to Map<String, dynamic>
//         var data = document.data()! as Map<String, dynamic>;

//         // Check if the data contains the 'location' key
//         if (data.containsKey('longitude')) {
//           // Retrieve the 'location' field value
//           dynamic Longitude = data['longitude'];

//           // Add the location to the List
//           Logitudes.add(Longitude);
//         }
//       }
//     }

//     return Logitudes;
//   } catch (e) {
//     print('Error retrieving locations: $e');
//     return []; // Return an empty list in case of an error
//   }
// }

// //Latitudes

// Future<List<double>> retrieveAllLatitudes() async {
//   // Reference to the Firestore collection named 'tailor'
//   CollectionReference tailorCollection =
//       FirebaseFirestore.instance.collection(usersCollection1);

//   List<double> Latitudes = [];

//   try {
//     // Get all documents in the 'tailor' collection
//     QuerySnapshot querySnapshot = await tailorCollection.get();

//     // Iterate through the documents and retrieve the 'location' field
//     for (QueryDocumentSnapshot document in querySnapshot.docs) {
//       // Check if the document exists and data is not null
//       if (document.exists && document.data() != null) {
//         // Explicitly cast data to Map<String, dynamic>
//         var data = document.data()! as Map<String, dynamic>;

//         // Check if the data contains the 'location' key
//         if (data.containsKey('latitude')) {
//           // Retrieve the 'location' field value
//           dynamic Latitude = data['latitude'];

//           // Add the location to the List
//           Latitudes.add(Latitude);
//         }
//       }
//     }

//     return Latitudes;
//   } catch (e) {
//     print('Error retrieving locations: $e');
//     return []; // Return an empty list in case of an error
//   }
// }



// void main() async {
//   List<String> allLocations = await retrieveAllLocations();

//   // Print all locations
//   print('All Locations: $allLocations');
// }

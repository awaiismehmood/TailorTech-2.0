import 'dart:async';
import 'dart:math' show atan2, cos, pi, sin, sqrt;
import 'package:dashboard_new/Customer_views/Find_tailor/tailors_loc.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:dashboard_new/Customer_views/Find_tailor/tailor_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final String orderId;
  const MapPage({super.key, required this.orderId});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  var controller1 = Get.put(AuthController());

  List<Map<String, dynamic>> tailorLocations = [];

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  // BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;

  // static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  LatLng? _currentP;

  // void setCustomMarkerIcon() {
  //   BitmapDescriptor.fromAssetImage(
  //           ImageConfiguration.empty, "assets/images/Cust4.jpg")
  //       .then((icon) {
  //     sourceIcon = icon;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //setCustomMarkerIcon();
    getLocationUpdates();
    _loadTailorLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text(
                "Loading..",
              ),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: const CameraPosition(
                target: _pGooglePlex,
                zoom: 13,
              ),
              markers: _createMarkers(),
            ),
    );
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = <Marker>{};

    // Add markers for tailor locations
    for (int i = 0; i < tailorLocations.length; i++) {
      String tailorId = tailorLocations[i]['documentId'];
      double latitude = tailorLocations[i]['latitude']!;
      double longitude = tailorLocations[i]['longitude']!;
      LatLng tailorLocation = LatLng(latitude, longitude);

      double distance = _calculateDistance(_currentP!, tailorLocation);

      markers.add(
        Marker(
          markerId: const MarkerId("_currentLocation"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          position: _currentP!,
        ),
      );

      if (distance < 5) {
        markers.add(
          Marker(
            markerId: MarkerId(tailorId),
            position: LatLng(latitude, longitude),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TailorShow(
                      orderId: widget.orderId,
                      tailorId: tailorId,
                    ),
                  ));
            },
          ),
        );
      }
    }

    return markers;
  }

  Future<void> _loadTailorLocations() async {
    try {
      tailorLocations = await retrieveLocationData();
      setState(() {
        // Set state after loading tailor locations
      });
    } catch (error) {
      print('Error loading tailor locations: $error');
    }
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 15,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers

    // Convert degrees to radians
    double lat1 = p1.latitude * (pi / 180);
    double lon1 = p1.longitude * (pi / 180);
    double lat2 = p2.latitude * (pi / 180);
    double lon2 = p2.longitude * (pi / 180);

    // Haversine formula
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in kilometers
  }
}

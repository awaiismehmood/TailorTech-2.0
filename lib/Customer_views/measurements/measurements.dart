// ignore_for_file: library_private_types_in_public_api, avoid_unnecessary_containers, use_build_context_synchronously, duplicate_ignore

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/Customer_views/measurements/save_measurements.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  _MeasurementScreenState createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  File? _imageFile;
  final picker = ImagePicker();
  final TextEditingController _heightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose(); // Dispose controller
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _showImageDialog(bool isHardcode) async {
    if (_imageFile != null && !isHardcode) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              child: Image.file(
                _imageFile!,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    } else {
      if (isHardcode) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/image_1_50.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future<void> _sendMeasurementRequest(
      BuildContext context, String imagePath, String height) async {
    // Show circular progress indicator dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: SizedBox(
            width: 30.0, // Specify the desired width
            height: 150.0, // Specify the desired height
            child: SpinKitWaveSpinner(
              color: redColor,
              size: 70.0,
            ),
          ),
        );
      },
    );

    // URL of your API endpoint
    var url = Uri.parse('http://192.168.100.146:5000/measurements');

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Add the image file to the request
      var imageFile = File(imagePath);
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: imageFile.path.split('/').last,
      );

      // Add the image file to the request
      request.files.add(multipartFile);
      request.fields['height'] = height;

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Decode the response JSON
        var jsonResponse = await response.stream.bytesToString();
        var responseData = json.decode(jsonResponse);
        String data = responseData.entries
            .map((entry) => '${entry.key}: ${entry.value}')
            .join('\n');

// Split the data into lines
        List<String> lines = data.split('\n');

        Map<String, double> relevantData = {};

// Flag to start storing data when encountering "height"
        bool startStoring = false;

// Iterate over the lines and extract relevant data
        for (String line in lines) {
          if (startStoring && line.isNotEmpty) {
            // Split the line by ':' to separate the key and value
            List<String> parts = line.split(':');
            if (parts.length == 2) {
              String key = parts[0].trim();
              double value = double.tryParse(parts[1].trim()) ?? 0.0;
              relevantData[key] = value;
            }
          }
          if (line.startsWith('height')) {
            // Start storing data from the line starting with "height"
            startStoring = true;
          }
          if (line.startsWith('ankle')) {
            // Stop storing data when encountering "ankle"
            break;
          }
        }
        log("relevant data");
        print(relevantData['waist']);

// Initialize a list to store the relevant data
        // List<String> relevantData = [];

// Flag to start storing data when encountering "height"
        // bool startStoring = false;

// Iterate over the lines and store relevant data
        // for (String line in lines) {
        //   if (startStoring) {
        //     // Add the line to relevantData
        //     relevantData.add(line.trim());
        //   }
        //   if (line.startsWith('height')) {
        //     // Start storing data from the line starting with "height"
        //     startStoring = true;
        //   }
        //   if (line.startsWith('ankle')) {
        //     // Stop storing data when encountering "ankle"
        //     break;
        //   }
        // }
        // Ensure that responseData is a Map<String, dynamic>

        // Map<String, dynamic> relevantData = {};
        // if (responseData is Map<String, dynamic>) {
        //   // Extract the measurement data from the response

        //   bool startStoring = false;

        //   // Iterate over the response data and extract relevant measurements
        //   responseData.forEach((key, value) {
        //     if (startStoring && key != 'ankle') {
        //       relevantData[key] = value;
        //     }
        //     if (key == 'height') {
        //       // Start storing data from the key "height"
        //       startStoring = true;
        //     }
        //     if (key == 'ankle') {
        //       // Stop storing data when encountering "ankle"
        //       startStoring = false;
        //     }
        //   });
        //   log("relevsant data");
        //   print(relevantData['height']);
        // } else {
        //   print('Response data is not in the expected format.');
        // }

        try {
          // Get the current user's ID (replace this with your logic to get the user's ID)
          // Replace 'user123' with the actual user ID
          // Reference to the user's document
          // DocumentReference userRef = FirebaseFirestore.instance
          //     .collection('users')
          //     .doc(currentUser!.uid)
          //     .collection('measurements')
          //     .doc(currentUser?.uid);

          // // Create a 'measurements' subcollection within the user's document
          // // CollectionReference measurementsRef =
          // //     userRef.collection('measurements') .doc(currentUser!.uid);

          // await userRef
          //     .set({'measurements': responseData}, SetOptions(merge: true));

          // Dismiss the progress dialog
          Navigator.of(context).pop();

          // Navigate to the next screen
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => measurementsShow(
                      responseData: relevantData,
                      height: height,
                    )),
          );
        } catch (e) {
          // Handle errors
          print('Error saving measurement data to Firebase: $e');
          // Dismiss the progress dialog
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // Show error toast
          // ignore: use_build_context_synchronously
          VxToast.show(context,
              msg: 'Error saving measurement data to Firebase: $e',
              showTime: 5000);
        }
      } else {
        // Handle unsuccessful response
        print(
            'Failed to send measurement request. Status code: ${response.statusCode}');
        // Dismiss the progress dialog
        Navigator.of(context).pop();
        // Show error toast
        VxToast.show(context,
            msg:
                'Failed to send measurement request. Status code: ${response.statusCode}',
            showTime: 5000);
      }
    } catch (e) {
      // Handle errors
      print('Error sending measurement request: $e');
      // Dismiss the progress dialog
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // Show error toast
      // ignore: use_build_context_synchronously
      VxToast.show(context,
          msg: 'Error sending measurement request: $e', showTime: 5000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor, // Red app bar background color
        elevation: 10, // Add elevation for drop shadow
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white70, // You can change the border color here
                width: 2.0, // You can adjust the border width here
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Measurement Screen',
                style: TextStyle(
                  color: whiteColor,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: whiteColor, // White page background with 70% opacity
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Sample Image",
                    style: TextStyle(
                        fontSize: 25, fontFamily: semibold, color: whiteColor),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showImageDialog(false);
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: AspectRatio(
                      aspectRatio: _imageFile != null ? 0.8 : 1.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/image_1_50.png",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     _showImageDialog(false);
              //   },
              //   child: Container(
              //     margin: EdgeInsets.symmetric(horizontal: 20),
              //     child: Card(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       elevation: 5,
              //       child: AspectRatio(
              //         aspectRatio: _imageFile != null ? 1.0 : 16 / 10,
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(20),
              //           child: _imageFile != null
              //               ? Image.file(
              //                   _imageFile!,
              //                   fit: BoxFit.cover,
              //                 )
              //               : const Center(
              //                   child: Text(
              //                     'Tap the buttons below \n      to Select Image',
              //                     style: TextStyle(
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton(
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: redColor,
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    'Upload Photo',
                    style: TextStyle(color: whiteColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _getImage(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: whiteColor,
                    side: const BorderSide(color: redColor),
                  ),
                  child: const Text(
                    'Take Photo',
                    style: TextStyle(color: redColor),
                  ),
                ),
              ]),

              const SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.all(24.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       if (_imageFile != null) {
              //         _sendMeasurementRequest(context, _imageFile!.path);
              //       } else {
              //         print('No image selected.');
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(24),
              //       ),
              //       backgroundColor: redColor,
              //       side: const BorderSide(color: Colors.grey,width: 2,),

              //     ),
              //     child: const Text(
              //       'Measure',
              //       style: TextStyle(color: whiteColor),
              //     )
              //   )
              // ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Height (in inches)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_imageFile != null) {
                      String height = _heightController.text;
                      _sendMeasurementRequest(
                          context, _imageFile!.path, height);
                    } else {
                      print('No image selected.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Measure',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}

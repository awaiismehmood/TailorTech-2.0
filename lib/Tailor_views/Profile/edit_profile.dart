import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/routes/app_router.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  bool _isLoading = false;
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  String _selectedTailorType = 'Female Tailor';
  List<File> _selectedImages = [];
  File? _selectedProfileImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _detailsController = TextEditingController();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _selectImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty && pickedImages.length <= 5) {
      if (mounted) {
        setState(() {
          _selectedImages =
              pickedImages.map((image) => File(image.path)).toList();
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select between 1 and 5 images.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _selectProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      if (mounted) {
        setState(() {
          _selectedProfileImage = File(pickedImage.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: redColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Edit Profile',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _selectProfileImage,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: _selectedProfileImage != null
                          ? CircleAvatar(
                              radius: 56,
                              backgroundImage:
                                  FileImage(_selectedProfileImage!),
                            )
                          : Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: redColor,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _minPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Min Price'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _maxPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Max Price'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedTailorType,
              items: ['Male Tailor', 'Female Tailor']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _selectedTailorType = value!;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Tailor Type'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload Images of Pre-built Clothes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectImages,
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Select Images'),
            ),
            const SizedBox(height: 10),
            _selectedImages.isEmpty
                ? const Text('No images selected')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selected Images:'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _selectedImages.map((image) {
                          return SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.file(
                              image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_nameController.text.isNotEmpty &&
                          _detailsController.text.isNotEmpty &&
                          _selectedTailorType.isNotEmpty &&
                          _selectedImages.isNotEmpty &&
                          _selectedImages.length <= 5) {
                        _saveProfile();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please fill in all fields and select between 1 and 5 images.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: redColor,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    double minPrice = double.tryParse(_minPriceController.text) ?? 0.0;
    double maxPrice = double.tryParse(_maxPriceController.text) ?? 0.0;
    try {
      setState(() {
        _isLoading = true;
      });
      String profileImageUrl = '';
      if (_selectedProfileImage != null) {
        profileImageUrl = await _uploadImage(_selectedProfileImage!,
            folderName: 'profile_pictures');
      }

      await FirebaseFirestore.instance
          .collection('Tusers')
          .doc(currentUser?.uid)
          .update({
        'name': _nameController.text.trim(),
        'details': _detailsController.text.trim(),
        'T_type': _selectedTailorType,
        'ProfileImageurl': profileImageUrl,
        'profileSetup': true,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
      });

      List<String> imageUrls = [];
      for (var image in _selectedImages) {
        String imageUrl =
            await _uploadImage(image, folderName: 'Tailor_Pictures');
        imageUrls.add(imageUrl);
      }

      await FirebaseFirestore.instance
          .collection('Tusers')
          .doc(currentUser?.uid)
          .update({
        'images': imageUrls,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
        context.go(AppRoutes.tailorHome);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save profile. Please try again later.'),
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _uploadImage(File image, {String? folderName}) async {
    try {
      String folder = folderName ?? 'tailor_images';
      Reference reference = FirebaseStorage.instance.ref().child(
          '$folder/${currentUser?.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = reference.putFile(image);

      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      rethrow;
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'group_provider.dart';

class UploadProductImageScreen extends StatefulWidget {
  final BuildContext context;
  UploadProductImageScreen({super.key, required this.context});

  @override
  _UploadProductImageScreenState createState() => _UploadProductImageScreenState();
}

class _UploadProductImageScreenState extends State<UploadProductImageScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> _selectedFoodOrBodyCareItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInitialDialog();
    });
  }

  Future<void> _showInitialDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'What did you purchase?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10), // Reduce the height as needed
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        _showFoodDialogs();
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 45, // Increased radius
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/eatables.jpg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Eatables',
                            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        _showSkinCareDialogs();
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 45, // Increased radius
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/skincare.jpg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'BodyCare',
                            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFoodDialogs() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showInitialDialog();
                },
              ),
              Text(
                'What did you eat?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          content: Material(
            color: Colors.transparent,
            child: Container(
              width: 200,
              height: 300,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _foodOrBodyCareOption('assets/makeuse31.jpg', 'Milk'),
                  _foodOrBodyCareOption('assets/makeuse32.jpg', 'Eggs'),
                  _foodOrBodyCareOption('assets/makeuse33.jpg', 'Soya'),
                  _foodOrBodyCareOption('assets/makeuse34.jpg', 'Fish'),
                  _foodOrBodyCareOption('assets/makeuse35.jpg', 'Fruits'),
                  _foodOrBodyCareOption('assets/makeuse36.jpg', 'Veggies'),
                  _foodOrBodyCareOption('assets/makeuse37.jpg', 'Nonveg'),
                  _foodOrBodyCareOption('assets/makeuse38.jpg', 'Biscuits'),
                  _foodOrBodyCareOption('assets/makeuse39.jpg', 'Snacks'),
                  _foodOrBodyCareOption('assets/makeuse40.jpg', 'Cooldrinks'),
                  _foodOrBodyCareOption('assets/makeuse40.jpg', 'Other items'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSkinCareDialogs() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showInitialDialog();
                },
              ),
              Text(
                'What did you buy?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          content: Material(
            color: Colors.transparent,
            child: Container(
              width: 200,
              height: 300,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _foodOrBodyCareOption('assets/icon1.jpg', 'Soap'),
                  _foodOrBodyCareOption('assets/icon1.jpg', 'FaceCream'),
                  _foodOrBodyCareOption('assets/icon1.jpg', 'Shampoo'),
                  _foodOrBodyCareOption('assets/icon1.jpg', 'Group D'),
                  _foodOrBodyCareOption('assets/icon1.jpg', 'Group E'),
                  _foodOrBodyCareOption('assets/icon1.jpg', 'Group F'),
                  _foodOrBodyCareOption('assets/icon1.jpg', 'Group G'),
                  _foodOrBodyCareOption('assets/icon1.jpg', 'Group H'),
                  _foodOrBodyCareOption('assets/icon1.jpg', 'Group I'),
                  _foodOrBodyCareOption('assets/icon1.jpg', 'Group J'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _foodOrBodyCareOption(String iconPath, String item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(4.0),
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 2),
              image: DecorationImage(
                image: AssetImage(iconPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.green, size: 30),
            onPressed: () {
              setState(() {
                _selectedFoodOrBodyCareItems.add(item);
              });
              Navigator.of(context).pop();
              _showItemAddedDialog(item);
            },
          ),
        ],
      ),
    );
  }

  // // Widget _skinCareOption(String iconPath, String group) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 4.0),
  //     padding: const EdgeInsets.all(4.0),
  //     height: 60,
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.green, width: 2),
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 60,
  //           height: 60,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             border: Border.all(color: Colors.green, width: 2),
  //             image: DecorationImage(
  //               image: AssetImage(iconPath),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         SizedBox(width: 10),
  //         Expanded(
  //           child: Text(
  //             group,
  //             style: TextStyle(
  //               color: Colors.black,
  //               decoration: TextDecoration.none,
  //             ),
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.add, color: Colors.green, size: 30),
  //           onPressed: () {
  //             setState(() {
  //               _selectedSkinCareItems.add(group);
  //             });
  //             Navigator.of(context).pop();
  //             _showItemAddedDialog(group);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _showItemAddedDialog(String item) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Item Added', style: TextStyle(color: Colors.green)),
          content: Text('$item has been added successfully!', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && context.mounted) {
      _showImageDialog(context, pickedFile, groupProvider.selectedGroups);
    }
  }

  Future<void> _captureImage(BuildContext context) async {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null && context.mounted) {
      _showImageDialog(context, image, groupProvider.selectedGroups);
    }
  }

  Future<void> _showImageDialog(BuildContext context, XFile image, dynamic selectedGroups) async {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(File(image.path), height: 100),
              const SizedBox(height: 10),
              const Text('Do you want to upload this image?', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (context.mounted) Navigator.of(context).pop();
                await _uploadImage(image, selectedGroups);
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _uploadImage(XFile image, dynamic selectedGroups) async {
  try {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    final uploadUrl = Uri.parse('http://10.0.2.2:5000/uploadProduct');
    final request = http.MultipartRequest('POST', uploadUrl)
      ..files.add(await http.MultipartFile.fromPath('file', image.path));
    
    request.fields['user_id'] = userId.toString();
    
    if (selectedGroups is List<String>) {
      request.fields['selectedGroups'] = selectedGroups.join(',');
    } else if (selectedGroups is String) {
      request.fields['selectedGroups'] = selectedGroups;
    }

    // Add selected food and skincare items to the request
    request.fields['selectedFoodOrBodyCareItems'] = jsonEncode(_selectedFoodOrBodyCareItems);
    // request.fields['selectedSkinCareItems'] = jsonEncode(_selectedSkinCareItems);

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final responseData = jsonDecode(responseBody);
      final genrep = responseData['genrep'];
      debugPrint('hi shabbu**************');
      await Future.delayed(const Duration(seconds: 15));
      debugPrint('hi shabbu*******');
      if (context.mounted) {
        _showSuccessDialog(context, genrep);
      } else {
        debugPrint('hi satya chary');
      }

      return genrep;
    } else {
      return 'Image upload failed: $responseBody';
    }
  } catch (e) {
    return 'Image upload failed: $e';
  }
}

  void _showSuccessDialog(BuildContext context, genrep) async {
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Image uploaded successfully'),
          actions: [
            TextButton(
              onPressed: () {
                if (context.mounted) Navigator.of(context).pop();
                Future.delayed(Duration.zero, () {
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(
                      '/generated_report',
                      arguments: {'genrep': genrep},
                    );
                  }
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white), 
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _captureImage(context),
                  child: Image.asset(
                    'assets/camera.jpg', // Your icon1 image path
                    width: 100,
                    height: 100,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.green, width: 2),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: const Size.fromHeight(50),
                ),
                icon: Image.asset(
                  'assets/pickimage.png', // Your icon2 image path
                  width: 24,
                  height: 24,
                ),
                label: const Text(
                  'Pick Image',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

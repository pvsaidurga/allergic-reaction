import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadHealthPrescriptionScreen extends StatefulWidget {
  final int userId;

  const UploadHealthPrescriptionScreen({super.key, required this.userId});
  
  @override
  _UploadHealthPrescriptionScreenState createState() =>
      _UploadHealthPrescriptionScreenState();
}

class _UploadHealthPrescriptionScreenState extends State<UploadHealthPrescriptionScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
    } on Exception {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes != '-1') {
      _showScanSuccessDialog(barcodeScanRes);
      _showUploadDialog();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (!mounted) return;
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _showUploadDialog();
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    try {
      if (_imageFile == null) return;

      String url = 'http://10.0.2.2:5000/uploadhealthprescription';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files
          .add(await http.MultipartFile.fromPath('file', _imageFile!.path));
      request.fields['user_id'] = widget.userId.toString();

      var response = await request.send();

      if (response.statusCode == 200) {
        if (!mounted) return;
        _showUploadSuccessDialog('Uploaded Successfully');
      } else {
        throw Exception('Failed to upload health prescription');
      }
    } catch (e) {
      print('Error during file upload: $e');
      if (!mounted) return;
      _showUploadSuccessDialog('Failed to upload');
    }
  }

  void _showUploadDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Want to upload?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadImage(context);
              },
              child: const Text(
                'Upload',
              ),
            ),
          ],
        );
      },
    );
  }

  void _showScanSuccessDialog(String barcodeResult) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'Scanned Barcode: $barcodeResult',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUploadSuccessDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: message == 'Uploaded Successfully' ? Colors.green : Colors.red,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: message == 'Uploaded Successfully' ? Colors.green : Colors.red,
                ),
              ),
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
        title: const Text('Upload Health Prescription', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        elevation: 0, // Removes the shadow/border at the bottom
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _scanBarcode,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.green, size: 100),
                      Text(
                        'Scan Here',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.green,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextButton(
                onPressed: _pickImage,
                child: const Text(
                  'Pick Image',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GeneratedReportScreen extends StatelessWidget {
  const GeneratedReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final genrep = arguments != null ? arguments['genrep'] : 'Your generated report will appear here.';
    List<Map<String, String>> reportData = _parseGenrep(genrep);
    debugPrint('Report Data: $reportData');
    
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Generated Report',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/upload_screen'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              if (reportData.isEmpty)
                Text(
                  'Your generated report will appear here.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              if (reportData.isNotEmpty)
                Column(
                  children: reportData.map((data) {
                    return Container(
                      width: screenWidth - 32, // Set width to screen width minus padding
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredient: ${data['Ingredient']}', // Corrected key
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Level of Harm: ${data['Level of harm']}', // Corrected key
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Recommendation: ${data['Recommendation']}', // Corrected key
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _showDetailsDialog(context, data['Summary']!); // Corrected key
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                                ),
                              ),
                              child: Text('View Details'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement download functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Download Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _parseGenrep(String genrep) {
    List<Map<String, String>> result = [];
    List<String> entries = genrep.split('\n\n'); // Split entries by double newline

    for (String entry in entries) {
      Map<String, String> data = {};
      List<String> lines = entry.split('\n'); // Split lines within each entry

      for (String line in lines) {
        List<String> parts = line.split(': '); // Split key-value pairs by ': '

        if (parts.length == 2) {
          data[parts[0].trim()] = parts[1].trim(); // Assign key-value pair
        } else {
          // Log an error or handle unexpected data format
          print('Unexpected data format in line: $line');
        }
      }

      if (data.isNotEmpty) {
        result.add(data); // Add parsed entry to result list
      }
    }

    return result;
  }

  void _showDetailsDialog(BuildContext context, String details) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Recommendation Details'),
          content: Text(details, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

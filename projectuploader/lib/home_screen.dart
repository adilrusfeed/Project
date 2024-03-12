// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:projectuploader/detail_screen.dart';
import 'package:projectuploader/model/model.dart';
import 'package:projectuploader/service/service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FileInfo> uploadedFiles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUploadedFiles();
  }

  Future<void> loadUploadedFiles() async {
    setState(() {
      isLoading = true;
    });
    List<FileInfo> files = await FirebaseService.getUploadedFiles();
    setState(() {
      uploadedFiles = files;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Tem Storage ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            centerTitle: true,
            elevation: 4, // Add elevation to the app bar
            backgroundColor: Color.fromARGB(
                255, 189, 178, 207) // Set app bar background color
            ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : uploadedFiles.isEmpty
                ? Center(
                    child: Text('No files uploaded yet.'),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 25.0,
                      mainAxisSpacing: 25.0,
                    ),
                    itemCount: uploadedFiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                fileInfo: uploadedFiles[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Image.network(
                                  uploadedFiles[index].fileUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                // adding: const EdgeInsets.all(8.0),
                                child: Text(
                                  uploadedFiles[index].fileName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov'],
              );

              if (result != null) {
                PlatformFile file = result.files.first;
                File pickedFile = File(file.path!);

                // Check file size
                int fileSizeInBytes = pickedFile.lengthSync();
                if (fileSizeInBytes > 10 * 1024 * 1024) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('File Size Exceeded'),
                        content: Text(
                          'The selected file exceeds 10 MB. Please select a file smaller than 10 MB.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                // Proceed with file upload
                String? downloadUrl =
                    await FirebaseService.uploadFile(pickedFile);
                if (downloadUrl != null) {
                  FileInfo fileInfo = FileInfo(
                    fileName: basename(file.path!),
                    fileUrl: downloadUrl,
                    fileSize: fileSizeInBytes,
                  );
                  await FirebaseService.addFileDetails(fileInfo);
                  setState(() {
                    uploadedFiles.add(fileInfo);
                  });
                } else {
                  // Show alert for file upload failure
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('File Upload Failed'),
                        content: Text(
                          'The selected file could not be uploaded. Please try again later.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            tooltip: 'Upload File',
            child: Column(
              children: [
                Icon(
                  Icons.add,
                ),
                Text('Add'),
              ],
            )));
  }
}

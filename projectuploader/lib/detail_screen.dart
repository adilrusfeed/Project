// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:projectuploader/model/model.dart';

class DetailScreen extends StatelessWidget {
  final FileInfo fileInfo;

  const DetailScreen({Key? key, required this.fileInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(fileInfo.fileUrl),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Name: ${fileInfo.fileName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Size: ${fileInfo.fileSize} bytes',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

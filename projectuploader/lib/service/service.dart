import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectuploader/model/model.dart';

class FirebaseService {
  static final CollectionReference filesCollection =
      FirebaseFirestore.instance.collection('files');

  static Future<String?> uploadFile(File file) async {
    try {
      String fileName = basename(file.path);
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log('Error uploading file: $e');
      return null;
    }
  }

  static Future<void> addFileDetails(FileInfo fileInfo) async {
    try {
      await filesCollection.add(fileInfo.toJson());
    } catch (e) {
      log('Error adding file details: $e');
    }
  }

  static Future<List<FileInfo>> getUploadedFiles() async {
    List<FileInfo> uploadedFiles = [];
    try {
      QuerySnapshot querySnapshot = await filesCollection.get();
      querySnapshot.docs.forEach((doc) {
        uploadedFiles
            .add(FileInfo.fromJson(doc.data() as Map<String, dynamic>));
      });
    } catch (e) {
      log('Error fetching uploaded files: $e');
    }
    return uploadedFiles;
  }
}

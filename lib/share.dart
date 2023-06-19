import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class share extends StatefulWidget {
  final String RoomId;
  share({required this.RoomId});

  @override
  State<share> createState() => _shareState(RoomId: RoomId);
}

class _shareState extends State<share> {
  final String RoomId;
  _shareState({required this.RoomId});
  late Future<ListResult> futureFiles;
  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/$RoomId/').listAll();
  }

  Future<void> _downloadFile(String fileName) async {
    String savePath = '/Download/$fileName'; // เส้นทางที่คุณต้องการบันทึกไฟล์

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('/$RoomId/$fileName');
    File file = File(savePath);

    try {
      await ref.writeToFile(file);
      print('File downloaded and saved successfully!');
    } catch (e) {
      print('Download error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Files'),
      ),
      body: FutureBuilder<ListResult>(
        future: futureFiles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final files = snapshot.data!.items;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text(file.name),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      Reference ref =
                          FirebaseStorage.instance.ref().child(file.fullPath);
                      String downloadURL = await ref.getDownloadURL();
                      await Share.share('$downloadURL');
                      print('Download URL: $downloadURL');
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

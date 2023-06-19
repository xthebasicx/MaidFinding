import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:project/chatlll.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:project/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class chatll extends StatefulWidget {
  final String RoomId;
  chatll({required this.RoomId});

  @override
  State<chatll> createState() => _chatllState(RoomId: RoomId);
}

class _chatllState extends State<chatll> {
  final String RoomId;
  _chatllState({required this.RoomId});

  File? image;
  Future pickImange() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  File? video;
  Future pickVideo() async {
    try {
      final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (video == null) return;
      final videoTemporary = File(video.path);
      setState(() => this.video = videoTemporary);
    } on PlatformException catch (e) {
      print("Failed to pick Video: $e");
    }
  }

  Future upload() async {
    if (image != null) {
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileExtension = path.extension(image!.path);
      final fileName = '$timestamp$fileExtension';
      final imagePath = '/$RoomId/$fileName';
      final file = File(image!.path);
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      await ref.putFile(file);
    }
    if (video != null) {
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileExtension = path.extension(video!.path);
      final fileName = '$timestamp$fileExtension';
      final videoPath = '/$RoomId/$fileName';
      final file = File(video!.path);
      final ref = FirebaseStorage.instance.ref().child(videoPath);
      await ref.putFile(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            image != null
                ? Image.file(
                    image!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : FlutterLogo(
                    size: 160,
                  ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: video != null ? Text('$video') : Container(),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () => pickImange(),
                            child: Text('Select Image')),
                        ElevatedButton(
                            onPressed: () => pickVideo(),
                            child: Text('Select Video')),
                        ElevatedButton(
                            onPressed: () => upload(),
                            child: Text('Upload File')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

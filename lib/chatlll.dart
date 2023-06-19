import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';

class chatlll extends StatefulWidget {
  final String RoomId;
  chatlll({required this.RoomId});

  @override
  State<chatlll> createState() => _chatlllState(RoomId: RoomId);
}

class _chatlllState extends State<chatlll> {
  final String RoomId;
  _chatlllState({required this.RoomId});
  late Future<ListResult> futureFiles;
  Map<int, double> downloadProgress = {};
  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/$RoomId/').listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Files'),
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
                double? progress = downloadProgress[index];
                return ListTile(
                  title: Text(file.name),
                  subtitle: progress != null
                      ? LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.black26,
                        )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.download,
                      color: Colors.black,
                    ),
                    onPressed: () => downloadFile(index, file),
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

  Future downloadFile(int index, Reference ref) async {
    final url = await ref.getDownloadURL();
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${ref.name}';
    await Dio().download(url, path, onReceiveProgress: (received, total) {
      double progress = received / total;
      setState(() {
        downloadProgress[index] = progress;
      });
    });
    if (url.contains('.mp4')) {
      await GallerySaver.saveVideo(path, toDcim: true);
    } else if (url.contains('.jpg')) {
      await GallerySaver.saveImage(path, toDcim: true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloaded ${ref.name}'),
      ),
    );
  }
}

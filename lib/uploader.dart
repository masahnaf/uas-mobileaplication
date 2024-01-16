import "package:flutter/material.dart";
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
final FirebaseStorage _storage = FirebaseStorage.instance;

class UploaderPage extends StatefulWidget {
  const UploaderPage({super.key});
  @override
  _UploaderPageState createState() => _UploaderPageState();
}

class _UploaderPageState extends State<UploaderPage> {
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png']);
      if (result != null && result.files.isNotEmpty) {
        final Reference ref = _storage
            .ref()
            .child('images/$DateTime.now().millisecondsSinceEpoch.jpg');
        if (kIsWeb) {
          Uint8List? _fileBytes = result.files.first.bytes;
          if (_fileBytes != null) {
            await ref.putData(_fileBytes);
          }
        } else {
          File _imageFile = File(result.files.single.path!);
          await ref.putFile(_imageFile);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Berhasil"),
              duration: Duration(seconds: 5),
            ),
          );
        }
        Navigator.pop(context);
      } else
        Navigator.pop(context);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pengunggah Gambar")),
      body: Column(
        children: [
          Center(
            child: Container(
                margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                    onPressed: () {
                      //TODO Pilih dan Unggah
                      pickFile();
                    },
                    child: Text(
                      "Pilih dan Unggah",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ))),
          )
        ],
      ),
    );
  }
}

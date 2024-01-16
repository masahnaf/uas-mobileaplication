import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'edit.dart';
import 'uploader.dart';
import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

class ProfilePage extends StatefulWidget {
  ProfilePage({required this.NIM});
  final String NIM;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<dynamic, dynamic> mappedData = {};
  String NIM = "";
  @override
  void initState() {
    super.initState();
    NIM = widget.NIM;
    fetchData(NIM);
  }

  Future<void> fetchData(String NIM) async {
    final ref = _databaseReference.child("Mahasiswa").child(NIM);
    final data = await ref.get();
    setState(() {
      mappedData = data.value as Map<dynamic, dynamic>;
    });
  }

  final confirmController = TextEditingController();
  bool _showDialog = false;

  void _openConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dialog Konfirmasi'),
          content: TextField(
            controller: confirmController,
            decoration: InputDecoration(
              labelText: 'Masukkan Password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                confirmController.clear();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                //TODO Hapus
                String curPass = confirmController.text;
                _databaseReference
                    .child("Mahasiswa")
                    .child(NIM)
                    .get()
                    .then((snapshot) {
                  Map<dynamic, dynamic> data =
                      snapshot.value as Map<dynamic, dynamic>;
                  String dbPass = data['password'];

                  if (curPass == dbPass) {
                    _databaseReference
                        .child("Mahasiswa")
                        .child(NIM)
                        .remove()
                        .then((result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Sukses"),
                          duration: Duration(seconds: 5),
                        ),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                          duration: Duration(seconds: 5),
                        ),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Password Salah"),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.toString()),
                      duration: Duration(seconds: 5),
                    ),
                  );
                });
              },
              child: Text('Konfirmasi'),
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
          title: Text('Profile Mahasiswa'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: FlutterLogo(
                  size: 80.0,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  // TODO Buka Halaman Upload
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new UploaderPage()));
                },
                child: Text("Upload Gambar",
                    style: TextStyle(color: Colors.blue, fontSize: 15))),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("NIM", style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 1,
                    ),
                    Container(
                        width: 300,
                        height: 25,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 1))),
                        child: Text(NIM,
                            style: TextStyle(fontSize: 20, height: 1.4))),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama", style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 1,
                    ),
                    Container(
                        width: 300,
                        height: 25,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 1))),
                        child: Text(mappedData['nama'].toString(),
                            style: TextStyle(fontSize: 20, height: 1.4))),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("E-Mail", style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 1,
                    ),
                    Container(
                        width: 300,
                        height: 25,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 1))),
                        child: Text(mappedData['email'].toString(),
                            style: TextStyle(fontSize: 20, height: 1.4))),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                    onPressed: () {
                      //TODO Update
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new EditProfilePage(
                                  NIM: NIM,
                                  Nama: mappedData['nama'],
                                  Email: mappedData['email'])));
                    },
                    child: Text(
                      "Ubah Profil",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ))),
            Container(
                margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                    onPressed: () {
                      //TODO Batalkan
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ))),
            Container(
                margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                    onPressed: () {
                      //TODO Hapus
                      _openConfirmationDialog();
                    },
                    child: Text(
                      "Hapus",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ))),
          ],
        )));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

class EditProfilePage extends StatefulWidget {
  EditProfilePage({required this.NIM, required this.Nama, required this.Email});
  final String NIM;
  final String Nama;
  final String Email;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String NIM = "";
  String Nama = "";
  String Email = "";

  @override
  void initState() {
    super.initState();
    NIM = widget.NIM;
    Nama = widget.Nama;
    Email = widget.Email;

    NIMControl.text = NIM;
  }

  final NIMControl = TextEditingController();
  final NamaControl = TextEditingController();
  final EmailControl = TextEditingController();
  final PasswordControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemGrey,
          middle: Text('Ubah Profile Mahasiswa'),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: CupertinoTextField(
                    placeholder: NIM,
                    controller: NIMControl,
                    enabled: false,
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: CupertinoTextField(
                    placeholder: Nama,
                    controller: NamaControl,
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: CupertinoTextField(
                    placeholder: Email,
                    controller: EmailControl,
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: CupertinoTextField(
                    placeholder: "Masukkan Password",
                    obscureText: true,
                    controller: PasswordControl,
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Center(
                      child: CupertinoButton.filled(
                          child: Text("Ubah Profil"),
                          onPressed: () {
                            String NIM = NIMControl.text;
                            String Nama = NamaControl.text;
                            String Email = EmailControl.text;
                            String Password = PasswordControl.text;

                            Map<String, String> data = {
                              'nim': NIM,
                              'nama': Nama,
                              'email': Email,
                              'password': Password,
                            };

                            _databaseReference
                                .child('Mahasiswa')
                                .child(NIM)
                                .set(data)
                                .then((value) {
                              Navigator.pop(context);
                            }).catchError((error) {
                              NamaControl.text = "";
                              EmailControl.text = "";
                              PasswordControl.text = "";
                            });
                          }))),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Center(
                      child: CupertinoButton.filled(
                          child: Text("Batal"),
                          onPressed: () {
                            Navigator.pop(context);
                          }))),
            ],
          ),
        ));
  }
}

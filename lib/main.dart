import 'package:flutter/material.dart';
import 'register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'profile.dart';
import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

//void main() => runApp(const MyApp());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Sistem Informasi Mahasiswa';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final NIMControl = TextEditingController();
  final PasswordControl = TextEditingController();
  @override
  void dispose() {
    NIMControl.dispose();
    PasswordControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistem Informasi Mahasiswa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  child: Image.asset("images/logo-ftik.png"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "NIM",
                  hintText: "Masukkan NIM Anda",
                ),
                controller: NIMControl,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  hintText: "Masukkan Password Anda",
                ),
                controller: PasswordControl,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  //TODO Firebase Login
                  String NIM = NIMControl.text;
                  String Password = PasswordControl.text;

                  _databaseReference
                      .child("Mahasiswa")
                      .child(NIM)
                      .get()
                      .then((snapshot) {
                    Map<dynamic, dynamic> data =
                        snapshot.value as Map<dynamic, dynamic>;
                    String dbPass = data['password'];
                    if (Password == dbPass) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Login Berhasil"),
                          duration: Duration(seconds: 5),
                        ),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new ProfilePage(NIM: NIM)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Login Gagal"),
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
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO Firebase Register
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new RegisterPage()));
              },
              child: Text(
                "Daftar Akun Mahasiswa",
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

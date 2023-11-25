import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:NCKH/screen/signin_screen.dart';

void main() async {
  // Trong phần main hoặc bất kỳ nơi nào trước khi thực hiện các thao tác Firebase
  print('Trying to connect to Firebase...');

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBAJjhR6CvLeDqZrsBDT_hXlYypowIFah8",
      authDomain: "nckh-376a0.firebaseapp.com",
      projectId: "nckh-376a0",
      databaseURL: 'https://nckh-376a0.firebasedatabase.app',
      storageBucket: "nckh-376a0.appspot.com",
      messagingSenderId: "725548516096",
      appId: "1:725548516096:web:9f3c3f845c3ce2bd81e9e5",
      measurementId: "G-RHQ8PJ1EB2",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}

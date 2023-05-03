import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_flutter/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'To-Do App',
    options: const FirebaseOptions(
      apiKey: "AIzaSyBzF376y_pSdR3zj4g_JnRyu5dk6EpCsaI",
      appId: "com.example.to_do_list_flutter",
      messagingSenderId: "246506530060",
      projectId: "todo-list-flutter-a0f23",
      authDomain: "todo-list-flutter-a0f23.firebaseapp.com",
      storageBucket: "todo-list-flu tter-a0f23.appspot.com"
    ),
  );
  runApp(const MyApp());
}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_flutter/app.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseOptions firebaseOptions = (Platform.isMacOS || Platform.isIOS)
    ? const FirebaseOptions(
        appId: '1:246506530060:ios:278425cc72938768d71529',
        messagingSenderId: '246506530060',
        apiKey: 'AIzaSyDtkNPspVqkfFz0EyvJ4QIuySAftzkUtIc',
        projectId: 'todo-list-flutter-a0f23',
        storageBucket: 'todo-list-flutter-a0f23.appspot.com',
      )
    : const FirebaseOptions(
       	apiKey: "AIzaSyBzF376y_pSdR3zj4g_JnRyu5dk6EpCsaI",
      	appId: "com.example.to_do_list_flutter",
      	messagingSenderId: "246506530060",
      	projectId: "todo-list-flutter-a0f23",
      	authDomain: "todo-list-flutter-a0f23.firebaseapp.com",
      	storageBucket: "todo-list-flu tter-a0f23.appspot.com"
      );
  await Firebase.initializeApp(
    name: 'to-do',
    options: firebaseOptions
  );
  runApp(const MyApp());
}
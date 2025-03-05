import 'package:flutter/material.dart';
import 'screens/folder_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FolderScreen(),
    );
  }
}
//charan
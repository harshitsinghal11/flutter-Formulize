import 'package:flutter/material.dart';
// Change this import to point to our new wrapper screen!
import 'features/home/screens/main_screen.dart';

void main() {
  runApp(const FormulizeApp());
}

class FormulizeApp extends StatelessWidget {
  const FormulizeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulize',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      // Change this to MainScreen!
      home: const MainScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:signs/home.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  
  WidgetsFlutterBinding.ensureInitialized(); // Required for Firebase
  await Firebase.initializeApp();

  runApp(sign());
}
class sign extends StatefulWidget {
  const sign({super.key});

  @override
  State<sign> createState() => _signState();
}

class _signState extends State<sign> {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final items = [
  Image.asset('assets/slide_1.jpg', fit: BoxFit.cover),
  Image.asset('assets/slide_1.jpg', fit: BoxFit.cover),
  Image.asset('assets/slide_1.jpg', fit: BoxFit.cover),
];

int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    print(FirebaseAuth.instance.currentUser!.email.toString());
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeView extends StatefulWidget {
  final User user;
  const HomeView({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.user.email.toString()),
        actions: [
          const SizedBox(height: 20.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              try {
                FirebaseAuth.instance.signOut();
                print("Sesión finalizada");
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              } catch (e) {
                print("Error al cerrar sesión: $e");
              }
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

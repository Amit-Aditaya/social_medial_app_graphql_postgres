import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raftlabs_flutter/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InkWell(
            onTap: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginScreen();
              }));
            },
            child: const Text('Logout')),
      ),
    );
  }
}

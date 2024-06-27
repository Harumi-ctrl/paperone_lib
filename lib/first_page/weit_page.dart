import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_one/first_page/navigation.dart';
import 'package:paper_one/item_page.dart';

import '../Login_SignUp/signup_login.dart';

class WaitPage extends ConsumerWidget {
  const WaitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return const BottomNavigationPage();
          }
          return SignUpLogin();
        },
      ),
    );
  }
}

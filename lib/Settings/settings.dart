import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:paper_one/Settings/cookie.dart';
import 'package:paper_one/Settings/notes.dart';
import 'package:paper_one/Settings/privacy.dart';
import 'package:paper_one/Settings/riyou.dart';

import '../Login_SignUp/from_anom_page.dart';
import '../Login_SignUp/signup_login.dart';
import 'account_page.dart';
import 'tokutei.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = FirebaseAuth.instance.currentUser;
    bool isAnonymous = user != null && user.isAnonymous;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              if (isAnonymous || user == null)
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FromAnomPage(),
                        ),
                      );
                    },
                    child: const Text("新規登録/ログインする"),
                  ),
                )
              else
                Container(),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                  child: const Text("アカウントについて"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountPage()),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (const Riyou()),
                      ),
                    );
                  },
                  child: const Text("利用規約"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (const PrivacyPolicy()),
                      ),
                    );
                  },
                  child: const Text("プライバシーポリシー"),
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // SizedBox(
              //   height: 50,
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   child: OutlinedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => (const Cookiee()),
              //         ),
              //       );
              //     },
              //     child: const Text("クッキーポリシー"),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (const Notes()),
                      ),
                    );
                  },
                  child: const Text("注意事項と免責事項"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (const TokuTeiPage()),
                      ),
                    );
                  },
                  child: const Text("特定商取引法に基づく表示"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

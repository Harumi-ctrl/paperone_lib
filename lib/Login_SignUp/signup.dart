import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_one/Login_SignUp/login_page.dart';
import 'package:paper_one/Settings/notes.dart';
import 'package:paper_one/Settings/privacy.dart';
import 'package:paper_one/Settings/riyou.dart';
import 'package:paper_one/item_page.dart';

import '../first_page/navigation.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends ConsumerState<SignUp> {
  //入力されたメールアドレスを入れるデータ
  String newUserEmail = '';
//入力されたパスワードを入れるデータ
  String newUserPassword = '';
// 登録・ログインに関する情報を表示するデータ
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'メールアドレス', border: OutlineInputBorder()),
                  onChanged: (String value) {
                    setState(() {
                      newUserEmail = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'パスワード', border: OutlineInputBorder()),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      newUserPassword = value;
                    });
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result =
                          await auth.createUserWithEmailAndPassword(
                        email: newUserEmail,
                        password: newUserPassword,
                      );
                      // 登録に成功した場合
                      setState(() {
                        infoText = '登録成功: ${result.user?.email}';
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigationPage(),
                        ),
                      );
                    } catch (e) {
                      // 登録に失敗した場合
                      setState(() {
                        infoText = '登録失敗: ${e.toString()}';
                      });
                    }
                  },
                  child: const Text('ユーザー登録'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (const Login()),
                      ),
                    );
                  },
                  child: const Text('ログイン画面へ'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signInAnonymously();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavigationPage(),
                      ),
                    );
                  },
                  child: const Text("登録せずに始める"),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Center(
                      child: Column(children: [
                    Text.rich(TextSpan(children: [
                      const TextSpan(
                          text: "新規登録するには",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "注意事項と免責事項",
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => (const Notes()),
                              ),
                            );
                          },
                      ),
                      const TextSpan(
                          text: "と", style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: '利用規約',
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => (const Riyou()),
                              ),
                            );
                          },
                      ),
                      const TextSpan(
                        text: 'と',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'プライバシーポリシー',
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => (const PrivacyPolicy()),
                              ),
                            );
                          },
                      ),
                      const TextSpan(
                        text: 'に同意の上ご利用ください。',
                        style: TextStyle(color: Colors.black),
                      ),
                    ])),
                  ]))),
            ],
          ),
        ),
      ),
    );
  }
}

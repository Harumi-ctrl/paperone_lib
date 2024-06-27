import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_one/Login_SignUp/reset_password.dart';
import 'package:paper_one/Settings/settings.dart';

import '../Login_SignUp/signup_login.dart';

class DeleteAccountPage extends ConsumerStatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  DeleteAccountPageState createState() => DeleteAccountPageState();
}

class DeleteAccountPageState extends ConsumerState<DeleteAccountPage> {
  String reloginUserEmail = '';
  String reloginUserPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text.rich(
                      TextSpan(text: "アカウントを削除するにはセキュリティ上、再ログインする必要があります。")),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'メールアドレス', border: OutlineInputBorder()),
                  onChanged: (String value) {
                    setState(() {
                      reloginUserEmail = value;
                    });
                  },
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
                      reloginUserPassword = value;
                    });
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),
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
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result =
                          await auth.signInWithEmailAndPassword(
                        email: reloginUserEmail,
                        password: reloginUserPassword,
                      );
                      // 再ログインに成功した場合
                      //final User? user = result.user;

                      try {
                        await FirebaseAuth.instance.currentUser?.delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('アカウントを削除しました'),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (SignUpLogin()),
                          ),
                        );
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    "エラーが発生しました。もし削除したい場合はha.yu.ma1212@gmail.comまでご連絡ください"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            });
                      }

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => (SettingsPage()),
                      //   ),
                      // );
                    } catch (e) {
                      // ログインに失敗した場合
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                  "ログインできませんでした。もし削除したい場合はha.yu.ma1212@gmail.comまでご連絡ください"),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: const Text('アカウントを削除する'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordPage(),
                        ),
                      );
                    },
                    child: const Text("パスワードを忘れた場合")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

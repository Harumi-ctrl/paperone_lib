import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_one/first_page/navigation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../BookMark/bookmark.dart';
import '../subscription/subscription_model.dart';

class FromAnomPage extends ConsumerStatefulWidget {
  const FromAnomPage({super.key});

  @override
  FromAnomPageState createState() => FromAnomPageState();
}

class FromAnomPageState extends ConsumerState<FromAnomPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> linkAccount() async {
    print("Starting linkAccount function"); // 最初のログ出力

    try {
      User? user = _auth.currentUser;
      print("Current user: $user"); // 現在のユーザーをログ出力

      if (user == null) {
        print("No user is currently signed in.");
        return;
      }

      String email = emailController.text;
      String password = passwordController.text;

      print("Creating credential with email: $email");
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      print("Linking credential to user: ${user.uid}");
      UserCredential userCredential = await user.linkWithCredential(credential);
      ref.read(authStateNotifierProvider.notifier).refreshUser();
      print("Account linked: ${userCredential.user?.email}");
    } catch (e) {
      print("An error occurred"); // 例外が発生したことをログ出力

      if (e is FirebaseAuthException) {
        print("FirebaseAuthException caught: ${e.code} - ${e.message}");

        switch (e.code) {
          case 'provider-already-linked':
            print("The provider is already linked to the user.");
            break;
          case 'invalid-credential':
            print("The provided credential is invalid.");
            break;
          case 'credential-already-in-use':
            print(
                "The account corresponding to the credential already exists.");
            break;
          case 'email-already-in-use':
            print("The email is already associated with another account.");
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('エラー'),
                    content: const Text('このメールアドレスはすでに使用されています'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                });
            break;
          case 'requires-recent-login':
            print(
                "This operation is sensitive and requires recent authentication. Log in again before retrying this request.");
            break;
          default:
            print("Failed to link account: ${e.message} (Code: ${e.code})");
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('エラー'),
                    content: Text(
                        "エラーが発生しました:ha.yu.ma1212@gmail.comに問い合わせてください ${e.message}"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                });
        }
      } else {
        print("Failed to link account: $e");
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('アカウントを作成する'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 180),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
              controller: emailController,
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                  labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
              controller: passwordController,
            ),
            const SizedBox(height: 20),
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
                  linkAccount();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('アカウントをリンクしました'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigationPage(),
                                  ),
                                );
                              },
                              child: const Text('購入しない'),
                            ),
                            TextButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                try {
                                  final inAppPurchaseManager = ref.read(
                                      inAppPurchaseManagerProvider.notifier);
                                  await inAppPurchaseManager.makePurchase(
                                      "paperone_month_offering_offering");
                                  // Optional: Refresh the subscription status
                                  await inAppPurchaseManager.getPurchaserInfo(
                                      await Purchases.getCustomerInfo());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavigationPage(),
                                      ));
                                } catch (e) {
                                  print('Error: $e');
                                } finally {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavigationPage(),
                                      ));
                                }
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigationPage(),
                                  ),
                                );
                              },
                              child: const Text('購入する'),
                            ),
                          ],
                        );
                      });
                },
                child: const Text('アカウントを作成する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

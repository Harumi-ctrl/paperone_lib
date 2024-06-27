import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_page.dart';
import 'signup.dart';

class SignUpLogin extends ConsumerStatefulWidget {
  @override
  SignUpLoginState createState() => SignUpLoginState();
}

class SignUpLoginState extends ConsumerState<SignUpLogin> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabAlignment: TabAlignment.center,
              isScrollable: true,
              tabs: [
                Tab(
                  text: '新規登録',
                ),
                Tab(
                  text: 'ログイン',
                ),
              ],
            )),
        backgroundColor: Colors.white,
        body: const TabBarView(
          children: [
            SignUp(),
            Login(),
          ],
        ),

        // body: Center(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const SizedBox(
        //         height: 20,
        //       ),
        //       SizedBox(
        //         height: 50,
        //         width: MediaQuery.of(context).size.width * 0.8,
        //         child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor: Colors.blue,
        //             foregroundColor: Colors.white,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(10),
        //             ),
        //           ),
        //           onPressed: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const SignUp(),
        //               ),
        //             );
        //           },
        //           child: const Text('新規登録へ'),
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 20,
        //       ),
        //       SizedBox(
        //         height: 50,
        //         width: MediaQuery.of(context).size.width * 0.8,
        //         child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor: Colors.blue,
        //             foregroundColor: Colors.white,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(10),
        //             ),
        //           ),
        //           onPressed: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const Login(),
        //               ),
        //             );
        //           },
        //           child: const Text('ログインへ'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

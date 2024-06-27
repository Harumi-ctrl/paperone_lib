// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class Cookiee extends ConsumerStatefulWidget {
//   const Cookiee({super.key});

//   @override
//   ConsumerState<Cookiee> createState() => CookieeState();
// }

// class CookieeState extends ConsumerState<Cookiee> {
//   bool isLosding = true;

//   @override
//   Widget build(BuildContext context) {
//     final controller = WebViewController()
//       ..loadRequest(Uri.parse(
//           'https://harumi91782072.wordpress.com/2024/06/08/%e8%ab%96%e6%96%87%e8%a6%81%e7%b4%84one-%e3%82%af%e3%83%83%e3%82%ad%e3%83%bc%e3%83%9d%e3%83%aa%e3%82%b7%e3%83%bc/'))
//       ..setJavaScriptMode(JavaScriptMode.unrestricted);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('クッキーポリシー'),
//       ),
//       body: WebViewWidget(
//         controller: controller,
//       ),
//     );
//   }
// }

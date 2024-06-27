import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TokuTeiPage extends ConsumerStatefulWidget {
  const TokuTeiPage({super.key});

  @override
  ConsumerState<TokuTeiPage> createState() => TokuTeiPageState();
}

class TokuTeiPageState extends ConsumerState<TokuTeiPage> {
  final String largetext = '''サービス名

プレミアムプラン

事業者名

小谷晴海

メールアドレス

ha.yu.ma1212@gmail.com

お問い合わせ先

https://portfolio2-c.web.app/より受け付けております

営業時間

平日 10:00～18:00

サービス提供期間

月額プラン・490円

なお、このプランは、所定の方法によりご解約いただかない限り自動更新となります。

利用料金

各プランの申込みページにてご案内する料金（税込み）となります。なお、無料体験期間はございません。サービスのご利用開始時に、自動的に利用料金の支払いが発生いたします。

利用料金以外にお客様に発生する料金等

サイトの閲覧、コンテンツのダウンロード、お問い合わせ等の際の電子メールの送受信時などに、所定の通信料が発生いたします。

支払方法

iOS アプリケーションにてお支払いいただく場合：AppStore にてお支払いいただきます。

支払時期

プレミアムサービスのご利用開始時に、ユーザー様が選択された期間分の利用料金を先払いにてお支払いいただきます。 更新前期間終了時までに同一の期間分の利用料金をお支払いいただくものとし、以後も同様となります。

サービスの提供時期

当社所定の手続き終了後、直ちにご利用頂けます。

事業者の責任

このアプリにある利用規約に定めます。

解約

ご解約のお申し出は原則いつでも可能です。ただし、ご解約の効力は、利用期間満了時において発生するものとします。ご解約の方法は下記です。

iOS アプリケーションの場合： 定期購読内容を表示、変更、または解約する場合はこのリンクを検索してみてください。「https://support.apple.com/ja-jp/HT202039」

推奨環境

論文oneの動作環境は下記とします。下記環境以外では、正常に動作しなかったり画面表示が崩れたりする可能性があります。ご利用いただいているブラウザ又はアプリの種類・バージョンをご確認いただき、動作環境でのご利用をお願いいたします。

iOS
OS：iOS 17.0 以降、iPadOS 17.0 以降
アプリバージョン：AppStore で提供している最新バージョン

特別条件

クーリングオフについて
特定商取引法に規定されるクーリング・オフが適用されるサービスではありません。

定期課金方式の注意事項
お支払いいただいた場合には返金には基本的に応じるには致しかねません''';
  List<String> paragraphs = [];

  TokuTeiPageState() {
    paragraphs = largetext.split('\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('特定商取引法に基づく表示'),
      ),
      body: ListView.builder(
        itemCount: paragraphs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              paragraphs[index],
              style: const TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}
//   bool isLosding = true;
//   @override
//   Widget build(BuildContext context) {
//     final controller = WebViewController()
//       ..loadRequest(Uri.parse(
//           'https://harumi91782072.wordpress.com/2024/06/21/%e7%89%b9%e5%ae%9a%e5%95%86%e5%8f%96%e5%bc%95%e6%b3%95%e3%81%ab%e9%96%a2%e3%81%99%e3%82%8b%e8%a1%a8%e7%a4%ba%e3%81%ab%e3%81%a4%e3%81%84%e3%81%a6/'))
//       ..setJavaScriptMode(JavaScriptMode.unrestricted);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('特定商取引法に基づく表示'),
//       ),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }

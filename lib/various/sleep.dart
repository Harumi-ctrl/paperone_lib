import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_one/datamodel.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../BookMark/bookmark.dart';
import '../Login_SignUp/from_anom_page.dart';
import '../detail_page.dart';
import '../subscription/subscription_model.dart';

// //睡眠のfirebaseを取得
// final sleepItemsProvider =
//     FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
//   QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('mydata')
//       .where('c', isEqualTo: "sleep")
//       .limit(10)
//       .get();
//   var docs = snapshot.docs;
//   docs.shuffle(Random());
//   return docs;
// });
final sleepItemsProviderTwo = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection('mydata')
      .where('c', isEqualTo: "sleep")
      .orderBy('timestamp', descending: true)
      .limit(10)
      .snapshots();
});

class Sleep extends ConsumerWidget {
  const Sleep({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepItemsAsyncValue = ref.watch(sleepItemsProviderTwo);
    /////
    ////
    final bookmarksAsyncValue = ref.watch(bookmarksProvider);
    //
    //
    final isSubscribedIOSsleep = ref.watch(inAppPurchaseManagerProvider);
    //
    //
    //
    //
    final user = ref.watch(authStateNotifierProvider);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(sleepItemsProviderTwo);
        },
        child: sleepItemsAsyncValue.when(
          data: (snapshot) {
            //
            //
            final bookmarkedItems = bookmarksAsyncValue.maybeWhen(
              data: (bookmarkSnapshot) =>
                  bookmarkSnapshot.docs.map((doc) => doc.data()).toList(),
              orElse: () => [],
            );
            //
            //
            var items = snapshot.docs;
            // var items = snapshot;
            // items.shuffle(Random());
            for (var item in items) {
              var data = item.data() as Map<String, dynamic>;
              var imageUrl = data['image'];
              precacheImage(CachedNetworkImageProvider(imageUrl), context);
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index].data() as Map<String, dynamic>;
                String title = item['title'];
                String imageUrl = item['image'];
                String text = item['content'];
                //
                //
                bool isBookmarked = bookmarkedItems
                    .any((bookmark) => bookmark['title'] == title);
                String? bookmarkId;
                if (isBookmarked) {
                  bookmarkId = bookmarksAsyncValue.maybeWhen(
                    data: (bookmarkSnapshot) {
                      return bookmarkSnapshot.docs.firstWhere(
                        (doc) {
                          final data = doc.data() as Map<String, dynamic>?;
                          return data != null && data['title'] == title;
                        },
                      ).id;
                    },
                    orElse: () => null,
                  );
                }
                //
                //

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 180,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        FirebaseAnalytics.instance.logEvent(
                          name: 'sleep_item_tapped',
                          parameters: {
                            'title': title,
                          },
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                                item: Item(
                                    title: item["title"],
                                    imageUrl: item["image"],
                                    text: item["content"])
                                // title: imageData["title"],
                                // imageUrl: imageData["image"],
                                // text: imageData["content"]
                                ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                                icon: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (user!.isAnonymous == false &&
                                      user != null) {
//特定アカウントの場合

                                    if (isSubscribedIOSsleep.isSubscribed ==
                                        true) {
                                      if (isBookmarked && bookmarkId != null) {
                                        ref
                                            .read(firestoreServiceProvider)
                                            .removeBookmark(
                                                user.uid, bookmarkId);
                                      } else {
                                        ref
                                            .read(firestoreServiceProvider)
                                            .addBookmark(user.uid, item);
                                      }
                                    } else if (isSubscribedIOSsleep
                                            .isSubscribed ==
                                        false) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'プレミアムプランに登録してください'),
                                              content: const Text(
                                                  '月額490円のプレミアムプランをご利用ください'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('キャンセル'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      },
                                                    );
                                                    try {
                                                      final inAppPurchaseManager =
                                                          ref.read(
                                                              inAppPurchaseManagerProvider
                                                                  .notifier);
                                                      await inAppPurchaseManager
                                                          .makePurchase(
                                                              "paperone_month_offering_offering");
                                                      // Optional: Refresh the subscription status
                                                      await inAppPurchaseManager
                                                          .getPurchaserInfo(
                                                              await Purchases
                                                                  .getCustomerInfo());
                                                      Navigator.of(context)
                                                          .pop();
                                                    } catch (e) {
                                                      print('Error: $e');
                                                    } finally {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  }
//匿名アカウントの場合
                                  if (user.isAnonymous == true) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('購入する前に'),
                                            content:
                                                const Text('新規登録またはログインしてください'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('キャンセル'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const FromAnomPage(),
                                                    ),
                                                  );
                                                },
                                                child: const Text('新規登録かログイン'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

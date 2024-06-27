import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_one/subscription/subscription_model.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../BookMark/bookmark.dart';
import '../Login_SignUp/from_anom_page.dart';
import '../datamodel.dart';
import '../detail_home_page.dart';
import '../detail_page.dart';

//一番上の画像スライドショーの画像を取得
final slideshowItemsProvider =
    FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('mydata').limit(10).get();
  var docs = snapshot.docs;
  //docs.shuffle(Random());
  return docs;
});
//最新の10件を取得
final latestItemsProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection('mydata')
      .orderBy('timestamp', descending: true)
      .limit(10)
      .snapshots();
});

//人間関係のfirebaseを取得
final humanItemsProvider =
    FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('mydata')
      .where('c', isEqualTo: "human")
      .limit(10)
      .get();
  var docs = snapshot.docs;
  docs.shuffle(Random());
  return docs;
});
//食のfirebaseを取得
final foodsItemsProvider =
    FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('mydata')
      .where('c', isEqualTo: "food")
      .limit(10)
      .get();
  var docs = snapshot.docs;
  docs.shuffle(Random());
  return docs;
});
//メンタルヘルスのfirebaseを取得
final mentalItemsProvider =
    FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('mydata')
      .where('c', isEqualTo: "mental")
      .limit(10)
      .get();
  var docs = snapshot.docs;
  docs.shuffle(Random());
  return docs;
});
//運動のfirebaseを取得
final workoutItemsProvider =
    FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('mydata')
      .where('c', isEqualTo: "workout")
      .limit(10)
      .get();
  var docs = snapshot.docs;
  docs.shuffle(Random());
  return docs;
});
//ライフスタイルのfirebaseを取得
final lifestyleItemsProvider =
    FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('mydata')
      .where('c', isEqualTo: "lifestyle")
      .limit(10)
      .get();
  var docs = snapshot.docs;
  docs.shuffle(Random());
  return docs;
});
//ビジネスのfirebaseを取得
final businessItemsProvider =
    FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('mydata')
      .where('c', isEqualTo: "business")
      .limit(10)
      .get();
  var docs = snapshot.docs;
  docs.shuffle(Random());
  return docs;
});
//睡眠のfirebaseを取得
final sleepItemsProvider =
    FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('mydata')
      .where('c', isEqualTo: "sleep")
      .limit(10)
      .get();
  var docs = snapshot.docs;
  docs.shuffle(Random());
  return docs;
});

class Home extends ConsumerWidget {
  const Home({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestItemsAsyncValue = ref.watch(latestItemsProvider);
    final slideshowItemsAsyncValue = ref.watch(slideshowItemsProvider);

    ////
    final bookmarksAsyncValue = ref.watch(bookmarksProvider);
    //
    //
    final isSubscribedIOShome = ref.watch(inAppPurchaseManagerProvider);
    //
    //
    //匿名アカウントか特定アカウントかなどを判定
    final user = ref.watch(authStateNotifierProvider);
    return DefaultTabController(
      initialIndex: 3,
      length: 8,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(slideshowItemsProvider);
            ref.refresh(latestItemsProvider);
          },
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: slideshowItemsAsyncValue.when(
                  data: (snapshot) {
                    //
                    //
                    final bookmarkedItems = bookmarksAsyncValue.maybeWhen(
                      data: (bookmarkSnapshot) => bookmarkSnapshot.docs
                          .map((doc) => doc.data())
                          .toList(),
                      orElse: () => [],
                    );
                    //
                    //
                    var items = snapshot;
                    for (var item in items) {
                      var data = item.data() as Map<String, dynamic>;
                      var imageUrl = data['image'];
                      precacheImage(
                          CachedNetworkImageProvider(imageUrl), context);
                    }
                    List<Map<String, dynamic>> imageDataList =
                        items.map((item) {
                      var data = item.data() as Map<String, dynamic>;
                      return {
                        'title': data['title'] as String,
                        'image': data['image'] as String,
                        'content': data['content'] as String,
                      };
                    }).toList();
                    // imageDataList.shuffle(Random());
                    imageDataList = imageDataList.take(10).toList();

                    return ImageSlideshow(
                      height: 250,
                      width: double.infinity,
                      initialPage: 0,
                      indicatorColor: Colors.blue,
                      indicatorBackgroundColor: Colors.grey,
                      onPageChanged: (value) {
                        debugPrint('Page changed: $value');
                      },
                      autoPlayInterval: 10000,
                      isLoop: true,
                      children: imageDataList.map((imageData) {
                        //
                        //
                        bool isBookmarked = bookmarkedItems.any((bookmark) =>
                            bookmark['title'] == imageData['title']);
                        String? bookmarkId;
                        if (isBookmarked) {
                          bookmarkId = bookmarksAsyncValue.maybeWhen(
                            data: (bookmarkSnapshot) {
                              return bookmarkSnapshot.docs.firstWhere(
                                (doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>?;
                                  return data != null &&
                                      data['title'] == imageData['title'];
                                },
                              ).id;
                            },
                            orElse: () => null,
                          );
                        }
                        //
                        //
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailHomePage(
                                    item: Item(
                                        title: imageData["title"],
                                        imageUrl: imageData["image"],
                                        text: imageData["content"])),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  imageUrl: imageData['image'],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  color: Colors.black45,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    imageData['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
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

                                          if (isSubscribedIOShome
                                                  .isSubscribed ==
                                              true) {
                                            if (isBookmarked &&
                                                bookmarkId != null) {
                                              ref
                                                  .read(
                                                      firestoreServiceProvider)
                                                  .removeBookmark(
                                                      user.uid, bookmarkId);
                                            } else {
                                              ref
                                                  .read(
                                                      firestoreServiceProvider)
                                                  .addBookmark(
                                                      user.uid, imageData);
                                            }
                                          } else if (isSubscribedIOShome
                                                  .isSubscribed ==
                                              false) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'プレミアムプランに登録してください'),
                                                    content: const Text(
                                                        '月額490円のプレミアムプランをご利用ください'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('キャンセル'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } catch (e) {
                                                            print('Error: $e');
                                                          } finally {
                                                            Navigator.of(
                                                                    context)
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
                                                  content: const Text(
                                                      '新規登録またはログインしてください'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('キャンセル'),
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
                                                      child: const Text(
                                                          '新規登録かログイン'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        }
                                      }))
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      Center(child: Text('Error: $error')),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '最新',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: latestItemsAsyncValue.when(
                  data: (snapshot) {
                    //
                    //
                    final bookmarkedItems = bookmarksAsyncValue.maybeWhen(
                      data: (bookmarkSnapshot) => bookmarkSnapshot.docs
                          .map((doc) => doc.data())
                          .toList(),
                      orElse: () => [],
                    );
                    //
                    //

                    var items = snapshot.docs;
                    for (var item in items) {
                      var data = item.data() as Map<String, dynamic>;
                      var imageUrl = data['image'];
                      precacheImage(
                          CachedNetworkImageProvider(imageUrl), context);
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
                                  final data =
                                      doc.data() as Map<String, dynamic>?;
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
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.darken),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                FirebaseAnalytics.instance.logEvent(
                                  name: 'latest_item_tapped_home',
                                  parameters: {
                                    'title': title,
                                  },
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailHomePage(
                                        item: Item(
                                            title: item["title"],
                                            imageUrl: item["image"],
                                            text: item["content"])),
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

                                            if (isSubscribedIOShome
                                                    .isSubscribed ==
                                                true) {
                                              if (isBookmarked &&
                                                  bookmarkId != null) {
                                                ref
                                                    .read(
                                                        firestoreServiceProvider)
                                                    .removeBookmark(
                                                        user.uid, bookmarkId);
                                              } else {
                                                ref
                                                    .read(
                                                        firestoreServiceProvider)
                                                    .addBookmark(
                                                        user.uid, item);
                                              }
                                            } else if (isSubscribedIOShome
                                                    .isSubscribed ==
                                                false) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'プレミアムプランに登録してください'),
                                                      content: const Text(
                                                          '月額490円のプレミアムプランをご利用ください'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'キャンセル'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
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
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            } catch (e) {
                                                              print(
                                                                  'Error: $e');
                                                            } finally {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }
                                                          },
                                                          child:
                                                              const Text('OK'),
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
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('購入する前に'),
                                                    content: const Text(
                                                        '新規登録またはログインしてください'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('キャンセル'),
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
                                                        child: const Text(
                                                            '新規登録かログイン'),
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  // onPressed: () {
  //                                     final user = ref.read(userProvider).value;
  //                                     switch (user!.isAnonymous == true) {
  //                                       case true:
  //                                         showDialog(
  //                                           context: context,
  //                                           builder: (BuildContext context) {
  //                                             return AlertDialog(
  //                                               title: const Text('購入する前に'),
  //                                               content: const Text(
  //                                                   '新規登録またはログインしてください'),
  //                                               actions: <Widget>[
  //                                                 TextButton(
  //                                                   onPressed: () {
  //                                                     Navigator.pop(context);
  //                                                   },
  //                                                   child: const Text('キャンセル'),
  //                                                 ),
  //                                                 TextButton(
  //                                                   onPressed: () {
  //                                                     Navigator.push(
  //                                                       context,
  //                                                       MaterialPageRoute(
  //                                                         builder: (context) =>
  //                                                             const FromAnomPage(),
  //                                                       ),
  //                                                     );
  //                                                   },
  //                                                   child: const Text('ログイン'),
  //                                                 ),
  //                                               ],
  //                                             );
  //                                           },
  //                                         );
  //                                         break;
  //                                       case false:
  //                                         if (isSubscribedIOShome
  //                                                 .isSubscribed ==
  //                                             true) {
  //                                           if (isBookmarked &&
  //                                               bookmarkId != null) {
  //                                             ref
  //                                                 .read(
  //                                                     firestoreServiceProvider)
  //                                                 .removeBookmark(
  //                                                     user!.uid, bookmarkId);
  //                                           } else {
  //                                             ref
  //                                                 .read(
  //                                                     firestoreServiceProvider)
  //                                                 .addBookmark(
  //                                                     user!.uid, imageData);
  //                                           }
  //                                         } else if (isSubscribedIOShome
  //                                                 .isSubscribed ==
  //                                             false) {
  //                                           showDialog(
  //                                             context: context,
  //                                             builder: (BuildContext context) {
  //                                               return AlertDialog(
  //                                                 title: const Text(
  //                                                     'プレミアムプランに登録してください'),
  //                                                 content: const Text(
  //                                                     '月額490円のプレミアムプランをご利用ください'),
  //                                                 actions: <Widget>[
  //                                                   TextButton(
  //                                                     onPressed: () {
  //                                                       Navigator.pop(context);
  //                                                     },
  //                                                     child:
  //                                                         const Text('キャンセル'),
  //                                                   ),
  //                                                   TextButton(
  //                                                     onPressed: () async {
  //                                                       showDialog(
  //                                                         context: context,
  //                                                         barrierDismissible:
  //                                                             false,
  //                                                         builder: (BuildContext
  //                                                             context) {
  //                                                           return const Center(
  //                                                             child:
  //                                                                 CircularProgressIndicator(),
  //                                                           );
  //                                                         },
  //                                                       );
  //                                                       try {
  //                                                         final inAppPurchaseManager =
  //                                                             ref.read(
  //                                                                 inAppPurchaseManagerProvider
  //                                                                     .notifier);
  //                                                         await inAppPurchaseManager
  //                                                             .makePurchase(
  //                                                                 "paperone_month_offering_offering");
  //                                                         // Optional: Refresh the subscription status
  //                                                         await inAppPurchaseManager
  //                                                             .getPurchaserInfo(
  //                                                                 await Purchases
  //                                                                     .getCustomerInfo());
  //                                                       } catch (e) {
  //                                                         print('Error: $e');
  //                                                       } finally {
  //                                                         Navigator.of(context)
  //                                                             .pop();
  //                                                       }
  //                                                     },
  //                                                     child: const Text('OK'),
  //                                                   ),
  //                                                 ],
  //                                               );
  //                                             },
  //                                           );
  //                                         }
  //                                         break;
  //                                       default:
  //                                         break;
  //                                     }
  //                                   }
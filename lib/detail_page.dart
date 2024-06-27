import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paper_one/subscription/subscription_model.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'BookMark/bookmark.dart';
import 'Login_SignUp/from_anom_page.dart';
import 'datamodel.dart';

final itemsProvider = StreamProvider<List<Item>>((ref) {
  return FirebaseFirestore.instance
      .collection('mydata')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Item(
        title: doc['title'],
        imageUrl: doc['image'],
        text: doc['content'],
      );
    }).toList();
  });
});

class DetailPage extends ConsumerStatefulWidget {
  final Item item;
  const DetailPage({super.key, required this.item});

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends ConsumerState<DetailPage> {
  String? bookmarkId;
  bool isBookmarked = false;

  @override
  Widget build(
    BuildContext context,
  ) {
    final itemsAsyncValue = ref.watch(itemsProvider);
    final isSubscribedIOSonDetail = ref.watch(inAppPurchaseManagerProvider);
    //
    final subscriptionState = ref.watch(subscriptionStateProvider);
    //
    //
    //
    //
    final user = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: itemsAsyncValue.when(
          data: (items) => Text(
            widget.item.title,
            style: const TextStyle(fontSize: 15),
          ),
          loading: () => const Text('Loading...'),
          error: (error, stackTrace) => const Text('Error'),
        ),
      ),
      body: itemsAsyncValue.when(
        data: (data) => Padding(
          padding: const EdgeInsets.all(1.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.item.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.item.title,
                    style: const TextStyle(
                        fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    isSubscribedIOSonDetail.isSubscribed
                        ? widget.item.text
                        : widget.item.text.substring(0, 300),
                    style: const TextStyle(fontSize: 15.0),
                  ),
                ),
                if (isSubscribedIOSonDetail.isSubscribed == false)
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
                        if (user!.isAnonymous == false) {
                          //特定アカウントの場合
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
                            final inAppPurchaseManager =
                                ref.read(inAppPurchaseManagerProvider.notifier);
                            await inAppPurchaseManager.makePurchase(
                                "paperone_month_offering_offering");
                            // Optional: Refresh the subscription status
                            await inAppPurchaseManager.getPurchaserInfo(
                                await Purchases.getCustomerInfo());
                          } catch (e) {
                            print('Error: $e');
                          } finally {
                            Navigator.of(context).pop();
                          }
                        }
                        if (user.isAnonymous == true) {
                          //匿名アカウントの場合、ログイン画面に遷移
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('購入する前に'),
                                  content: const Text('新規登録またはログインしてください'),
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
                      },
                      child: const Text('月額490円のプレミアムプランへ'),
                    ),
                  ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
//paperone_annual_1year


//                                       onPressed: () {
//                                           if (user!.isAnonymous == false &&
//                                               user != null) {
// //特定アカウントの場合

//                                             if (isSubscribedIOShome
//                                                     .isSubscribed ==
//                                                 true) {
//                                               if (isBookmarked &&
//                                                   bookmarkId != null) {
//                                                 ref
//                                                     .read(
//                                                         firestoreServiceProvider)
//                                                     .removeBookmark(
//                                                         user.uid, bookmarkId);
//                                               } else {
//                                                 ref
//                                                     .read(
//                                                         firestoreServiceProvider)
//                                                     .addBookmark(
//                                                         user.uid, item);
//                                               }
//                                             } else if (isSubscribedIOShome
//                                                     .isSubscribed ==
//                                                 false) {
//                                               showDialog(
//                                                   context: context,
//                                                   builder:
//                                                       (BuildContext context) {
//                                                     return AlertDialog(
//                                                       title: const Text(
//                                                           'プレミアムプランに登録してください'),
//                                                       content: const Text(
//                                                           '月額490円のプレミアムプランをご利用ください'),
//                                                       actions: <Widget>[
//                                                         TextButton(
//                                                           onPressed: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           child: const Text(
//                                                               'キャンセル'),
//                                                         ),
//                                                         TextButton(
//                                                           onPressed: () async {
//                                                             showDialog(
//                                                               context: context,
//                                                               barrierDismissible:
//                                                                   false,
//                                                               builder:
//                                                                   (BuildContext
//                                                                       context) {
//                                                                 return const Center(
//                                                                   child:
//                                                                       CircularProgressIndicator(),
//                                                                 );
//                                                               },
//                                                             );
//                                                             try {
//                                                               final inAppPurchaseManager =
//                                                                   ref.read(
//                                                                       inAppPurchaseManagerProvider
//                                                                           .notifier);
//                                                               await inAppPurchaseManager
//                                                                   .makePurchase(
//                                                                       "paperone_month_offering_offering");
//                                                               // Optional: Refresh the subscription status
//                                                               await inAppPurchaseManager
//                                                                   .getPurchaserInfo(
//                                                                       await Purchases
//                                                                           .getCustomerInfo());
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop();
//                                                             } catch (e) {
//                                                               print(
//                                                                   'Error: $e');
//                                                             } finally {
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop();
//                                                             }
//                                                           },
//                                                           child:
//                                                               const Text('OK'),
//                                                         ),
//                                                       ],
//                                                     );
//                                                   });
//                                             }
//                                           }
// //匿名アカウントの場合
//                                           if (user.isAnonymous == true) {
//                                             showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   return AlertDialog(
//                                                     title: const Text('購入する前に'),
//                                                     content: const Text(
//                                                         '新規登録またはログインしてください'),
//                                                     actions: <Widget>[
//                                                       TextButton(
//                                                         onPressed: () {
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                         child:
//                                                             const Text('キャンセル'),
//                                                       ),
//                                                       TextButton(
//                                                         onPressed: () {
//                                                           Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   const FromAnomPage(),
//                                                             ),
//                                                           );
//                                                         },
//                                                         child: const Text(
//                                                             '新規登録かログイン'),
//                                                       ),
                                        //             ],
                                        //           );
                                        //         });
                                        //   }
                                        // }
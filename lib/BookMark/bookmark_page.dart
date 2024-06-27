import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_one/datamodel.dart';
import 'package:paper_one/subscription/subscription_model.dart';

import '../detail_page.dart';
import 'bookmark.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addBookmark(
    String userId,
    Map<String, dynamic> bookmarkData,
  ) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .add(bookmarkData);
  }

  Stream<QuerySnapshot> getBookmarks(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .snapshots();
  }

  Future<void> removeBookmark(String userId, String bookmarkId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(bookmarkId)
        .delete();
  }
}

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inAppPurchaseManager = ref.watch(inAppPurchaseManagerProvider);

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // ユーザーがログインしていない場合の処理
      return Scaffold(
        appBar: AppBar(
          title: const Text('保存済み'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Text('ログインしてください'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(bookmarksProvider);
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('bookmarks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("保存された記事はありません"),
              );
            }

            List<String> bookmarkIds =
                snapshot.data!.docs.map((doc) => doc.id).toList();

            return ListView.builder(
                itemCount: bookmarkIds.length,
                // itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var bookmark =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  String title = bookmark['title'];
                  String imageUrl = bookmark['image'];
                  String text = bookmark['content'];
                  String bookmarkId = snapshot.data!.docs[index].id;

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                  item: Item(
                                title: bookmark["title"],
                                imageUrl: bookmark["image"],
                                text: bookmark["content"],
                              )),
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
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text('本当に削除しますか？'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('キャンセル'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                ref
                                                    .read(
                                                        firestoreServiceProvider)
                                                    .removeBookmark(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        bookmarkId);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('削除'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
//     } else {
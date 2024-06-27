import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paper_one/subscription/subscription_model.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

class DetailHomePage extends ConsumerStatefulWidget {
  final Item item;
  const DetailHomePage({super.key, required this.item});

  @override
  DetailHomePageState createState() => DetailHomePageState();
}

class DetailHomePageState extends ConsumerState<DetailHomePage> {
  String? bookmarkId;
  bool isBookmarked = false;

  @override
  Widget build(
    BuildContext context,
  ) {
    final itemsAsyncValue = ref.watch(itemsProvider);
    final isSubscribedIOS = ref.watch(inAppPurchaseManagerProvider);
    //
    final subscriptionState = ref.watch(subscriptionStateProvider);

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
                    widget.item.text,
                    style: const TextStyle(fontSize: 15.0),
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
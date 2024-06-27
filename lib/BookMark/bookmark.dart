import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bookmark_page.dart';

class AuthStateNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth;

  AuthStateNotifier(this._auth) : super(null) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = _auth.currentUser;
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }

  Future<void> refreshUser() async {
    state = _auth.currentUser;
  }
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, User?>(
  (ref) => AuthStateNotifier(FirebaseAuth.instance),
);
//
//
//
//
//
//
//
//
// Firestoreサービスプロバイダー
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// 認証済みユーザープロバイダー
final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ブックマークストリームプロバイダー
final bookmarksProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  final userAsyncValue = ref.watch(userProvider);

  return userAsyncValue.when(
    data: (user) {
      if (user != null) {
        return ref.watch(firestoreServiceProvider).getBookmarks(user.uid);
      } else {
        return const Stream.empty();
      }
    },
    loading: () => const Stream.empty(),
    error: (error, stackTrace) => const Stream.empty(),
  );
});

class BookmarkNotifier extends StateNotifier<Set<String>> {
  final FirestoreService firestoreService;
  final String _userId;

  BookmarkNotifier(this.firestoreService, this._userId) : super({});

  Future<void> addBookmark(Map<String, dynamic> item) async {
    await firestoreService.addBookmark(_userId, item);
    state = {...state, item['title']};
  }

  Future<void> removeBookmark(String bookmarkId, String title) async {
    await firestoreService.removeBookmark(_userId, bookmarkId);
    state = state.where((element) => element != title).toSet();
  }

  void setInitialBookmarks(Set<String> initialBookmarks) {
    state = initialBookmarks;
  }
}

final bookmarkNotifierProvider =
    StateNotifierProvider.family<BookmarkNotifier, Set<String>, String>(
        (ref, userId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return BookmarkNotifier(firestoreService, userId);
});

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final subscriptionStateProvider = FutureProvider<bool>((ref) async {
  // FirebaseAuthでサインインしているユーザーを取得します
  final user = ref.watch(authStateProvider).asData?.value;

  if (user == null) {
    return false;
  }

  // RevenueCatでサブスクリプション情報を取得します
  CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  return customerInfo.entitlements.active.isNotEmpty;
});

/////////////
//
//
//
//
//
//
//////ユーザーがサブスクアイテムを保有しているかの確認

final inAppPurchaseManagerProvider =
    ChangeNotifierProvider((ref) => InAppPurchaseManager());

class InAppPurchaseManager with ChangeNotifier {
  bool isSubscribed = false;
  Offerings? offerings;
  FirebaseAuth auth = FirebaseAuth.instance;

  InAppPurchaseManager() {
    initInAppPurchase(); // Initialize in the constructor
  }

  Future<void> initInAppPurchase() async {
    try {
      //consoleにdebug情報を出力する
      await Purchases.setLogLevel(LogLevel.debug);
      late PurchasesConfiguration configuration;

      if (Platform.isIOS) {
        configuration =
            PurchasesConfiguration("appl_aKMYvOcrdZDjlUamYdNJMjJmQXh");
      }
      await Purchases.configure(configuration);
      //offeringsを取ってくる
      offerings = await Purchases.getOfferings();
      final result = await Purchases.logIn(auth.currentUser!.uid);

      await getPurchaserInfo(result.customerInfo);

      //今アクティブになっているアイテムは以下のように取得可能
      print("アクティブなアイテム ${result.customerInfo.entitlements.active.keys}");
    } catch (e) {
      print("initInAppPurchase error caught! ${e.toString()}");
    }
  }

  Future<void> getPurchaserInfo(CustomerInfo customerInfo) async {
    try {
      isSubscribed = await updatePurchases(customerInfo,
          "paperone_month_entitlement"); //ここは、適宜ご自身のentitlement名に変えてください
      notifyListeners();
    } on PlatformException catch (e) {
      print(
          "getPurchaserInfo error ${PurchasesErrorHelper.getErrorCode(e).toString()}");
    }
  }

  Future<bool> updatePurchases(
      CustomerInfo purchaserInfo, String entitlement) async {
    var isPurchased = false;
    final entitlements = purchaserInfo.entitlements.all;
    if (entitlements.isEmpty) {
      isPurchased = false;
    }
    if (!entitlements.containsKey(entitlement)) {
      ///そもそもentitlementが設定されて無い場合
      isPurchased = false;
    } else if (entitlements[entitlement]!.isActive) {
      ///設定されていて、activeになっている場合
      isPurchased = true;
    } else {
      isPurchased = false;
    }
    return isPurchased;
  }

  /////////購入処理

  Future<void> makePurchase(String offeringsName) async {
    try {
      Package? package;
      package = offerings?.all[offeringsName]?.monthly;
      if (package != null) {
        await Purchases.logIn(auth.currentUser!.uid);
        CustomerInfo customerInfo = await Purchases.purchasePackage(package);
        await getPurchaserInfo(customerInfo);
        print("Purchase successful: ${package.identifier}");
      } else {
        print("package is null");
      }
    } on PlatformException catch (e) {
      print("purchase repo makePurchase error ${e.toString()}");
    }
  }

//////////購入復元処理
  Future<void> restorePurchase(String entitlement) async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      final isActive = await updatePurchases(customerInfo, entitlement);
      if (!isActive) {
        print("購入情報なし");
      } else {
        await getPurchaserInfo(customerInfo);
        print("$entitlement 購入情報あり 復元する");
      }
    } on PlatformException catch (e) {
      print("purchase repo  restorePurchase error ${e.toString()}");
    }
  }
}

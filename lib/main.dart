import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paper_one/first_page/weit_page.dart';
import 'package:paper_one/subscription/subscription_model.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final waitProvider = FutureProvider<void>((ref) async {
  // ここに非同期操作を記述
  await Future.delayed(const Duration(seconds: 1)); // 例として3秒待機
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings =
      InitializationSettings(iOS: initializationSettingsIOS);
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  await Purchases.setDebugLogsEnabled(true);
  await Purchases.configure(
      PurchasesConfiguration("appl_aKMYvOcrdZDjlUamYdNJMjJmQXh"));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  bool initialized = true;

  void setUpFirebaseListner() {
    FirebaseFirestore.instance
        .collection('mydata')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .listen((event) {
      if (initialized) {
        initialized = false;
        return;
      }
      event.docChanges.forEach((element) {
        if (element.type == DocumentChangeType.added) {
          final data = element.doc.data();
          if (data != null) {
            shoNotification(data);
          }
        }
      });
    });
  }

  void shoNotification(Map<String, dynamic> data) async {
    const DarwinNotificationDetails iOS = DarwinNotificationDetails();
    const platform = NotificationDetails(iOS: iOS);
    await FlutterLocalNotificationsPlugin().show(
      0,
      data['title'],
      data['content'],
      platform,
      payload: data['content'],
    );
  }

  Future<void> showAppTrackingTransparencyDialog() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      // await showCustomTrackingDialog(context);
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      await showAppTrackingTransparencyDialog();
    });
    super.initState();

    // setUpFirebaseListner();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WaitPage(),
    );
  }
}

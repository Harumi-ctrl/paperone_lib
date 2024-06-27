import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_one/BookMark/bookmark_page.dart';
import 'package:paper_one/various/business.dart';
import 'package:paper_one/various/food.dart';

import 'Settings/settings.dart';

import 'various/home.dart';
import 'various/human.dart';
import 'various/lifestyle.dart';
import 'various/mental.dart';
import 'various/sleep.dart';
import 'various/workout.dart';

class ItemListPage extends ConsumerStatefulWidget {
  const ItemListPage({super.key});

  @override
  ItemListPageState createState() => ItemListPageState();
}

class ItemListPageState extends ConsumerState<ItemListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "論文one",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            tabs: [
              Tab(
                text: 'ホーム',
              ),
              Tab(
                text: 'メンタル',
              ),
              Tab(
                text: 'ビジネス',
              ),
              Tab(
                text: 'ライフスタイル',
              ),
              Tab(
                text: '食',
              ),
              Tab(
                text: '睡眠',
              ),
              Tab(
                text: '運動',
              ),
              Tab(
                text: '人間関係',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Home(),
            Mental(),
            Business(),
            Lifestyle(),
            Food(),
            Sleep(),
            Workout(),
            Human(),
          ],
        ),
      ),
    );
  }
}

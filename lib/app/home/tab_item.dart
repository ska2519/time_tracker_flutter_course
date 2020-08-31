import 'package:flutter/material.dart';

enum TabItem { jobs, entry, account }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(title: 'Jobs', icon: Icons.work),
    TabItem.entry: TabItemData(title: 'entry', icon: Icons.view_headline),
    TabItem.account: TabItemData(title: 'account', icon: Icons.person),
  };
}

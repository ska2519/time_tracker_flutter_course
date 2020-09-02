import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/account/account_page.dart';
import 'package:time_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  //각 탭에 대한 global key를 배정 후 Map을 CupertinoHomeScaffold에 argument(인수)로 전달
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entry: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  //define a map that we can use to get the correct.
  //can declare the widget builders as key value pairs
  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entry: (context) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  //tab switching
  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      //pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    }
    setState(() => _currentTab = tabItem);
  }

  @override
  Widget build(BuildContext context) {
    //Control back button on Android
    //close and return a future of type boll
    //called Every time we press on the back button
    return WillPopScope(
      //- maybePop() more than 1 route -> pop and return ture / rotue 0 시 false 하지만 !<< 때문에 true
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}

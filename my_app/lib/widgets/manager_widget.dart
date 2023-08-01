import 'package:flutter/material.dart';
import 'package:my_app/states/index.dart';
import 'package:my_app/widgets/manager/disrtict_page.dart';
import 'package:my_app/widgets/manager/user_page.dart';
import 'package:provider/provider.dart';

import '../l10n/localization_intl.dart';
import 'common/vertical_tabs.dart';
import 'manager/community_page.dart';
import 'manager/daily_page.dart';
import 'manager/access_page.dart';
import 'manager/bulletin_page.dart';
import 'manager/suspect_page.dart';

class ManagerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ManagerWidgetState();
}

class ManagerWidgetState extends State<ManagerWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Tab> tabList;
  late List<Widget> tabBarList;

  @override
  void initState() {
    super.initState();
    tabList = [
      Tab(
        child: Container(
          alignment: Alignment.center,
          height: 30,
          child: Text("密接筛查", style: TextStyle(color: Colors.black)),
        ),
      ),
      Tab(
        child: Container(
          alignment: Alignment.center,
          height: 30,
          child: Text("人员流动", style: TextStyle(color: Colors.black)),
        ),
      ),
      Tab(
        child: Container(
          alignment: Alignment.center,
          height: 30,
          child: Text("每日健康", style: TextStyle(color: Colors.black)),
        ),
      ),
      Tab(
        child: Container(
          alignment: Alignment.center,
          height: 30,
          child: Text("用户管理", style: TextStyle(color: Colors.black)),
        ),
      ),
      Tab(
        child: Container(
          alignment: Alignment.center,
          height: 30,
          child: Text("小区管理", style: TextStyle(color: Colors.black)),
        ),
      ),
      Tab(
        child: Container(
          alignment: Alignment.center,
          height: 30,
          child: Text("社区管理", style: TextStyle(color: Colors.black)),
        ),
      ),
      Tab(
        child: Container(
          alignment: Alignment.center,
          height: 30,
          child: Text("公告管理", style: TextStyle(color: Colors.black)),
        ),
      ),
    ];
    tabBarList = <Widget>[
      SuspectPage(),
      AccessPage(),
      DailyPage(),
      UserPage(),
      DistrictPage(),
      CommunityPage(),
      BulletinPage(),
    ];
    _tabController = TabController(length: tabList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context);
    var gm = GmLocalizations.of(context);
    var flag = MediaQuery.of(context).size.width < 730;
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: flag
          ? Column(
              children: [
                TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: tabList,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: tabBarList,
                  ),
                )
              ],
            )
          : VerticalTabs(
              tabsWidth: 120,
              tabs: tabList,
              contents: tabBarList,
            ),
    );
  }
}

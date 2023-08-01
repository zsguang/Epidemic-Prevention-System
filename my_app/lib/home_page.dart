import 'package:flutter/material.dart';
import 'package:my_app/common/Network.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/widgets/home_widget.dart';
import 'package:my_app/widgets/manager_widget.dart';
import 'package:my_app/widgets/mine_widget.dart';
import 'package:provider/provider.dart';
import 'l10n/localization_intl.dart';
import 'models/user.dart';
import 'states/index.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int _selectedIndex = 0;
  late UserModel _userProvider;
  late GmLocalizations gm;
  late List<Widget> _bodyOptions;
  late List<BottomNavigationBarItem> _menuOptions;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {

    gm = GmLocalizations.of(context);

    return Consumer<UserModel>(
      builder: (context, userProvider, child) {
        _userProvider = userProvider;
        initData();
        showLog('home_page', userProvider.user.toString());

        return Scaffold(
            appBar: AppBar(
              title: Text(GmLocalizations.of(context).home),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.abc_sharp),
                  tooltip: 'Language',
                  onPressed: () => Navigator.of(context).pushNamed("language"),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: _menuOptions,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
            body: IndexedStack(index: _selectedIndex, children: _bodyOptions)
            // _bodyOptions[_selectedIndex], // 构建主页面
            // drawer: MyDrawer(), //抽屉菜单
            );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // showLog("home_page _onItemTapped", "index = $index,  _selectedIndex = $_selectedIndex");
    // showLog("home_page _onItemTapped",
    //     "bodyWidgets.length=${_bodyOptions.length}  _menuOptions.length=${_menuOptions.length}");
  }

  void initData() {
    if (_userProvider.user?.manager == '1') {
      _bodyOptions = <Widget>[HomeWidget(), ManagerWidget(), MineWidget()];
      _menuOptions = <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: gm.bmNavigationHome),
        BottomNavigationBarItem(icon: const Icon(Icons.account_tree), label: gm.bmNavigationManager),
        BottomNavigationBarItem(icon: const Icon(Icons.account_box_sharp), label: gm.bmNavigationMine)
      ];
    } else {
      _bodyOptions = <Widget>[HomeWidget(), MineWidget()];
      _menuOptions = <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: gm.bmNavigationHome),
        BottomNavigationBarItem(icon: const Icon(Icons.account_box_sharp), label: gm.bmNavigationMine),
      ];
    }
    if (_selectedIndex == 2 && _menuOptions.length == 2) {
      _selectedIndex = 1;
    }
  }

  void _getUserInfo() async {
    User? newUser = await Network(context).getUserInfo(Provider.of<UserModel>(context, listen: false).user);
    Provider.of<UserModel>(context, listen: false).user = newUser;
    // showLog("home_page _getUserInfo", '${newUser.toString()} ${newUser?.district.toString()}');
    setState(() {});
  }

}

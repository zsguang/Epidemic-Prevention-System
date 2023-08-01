import 'package:flutter/material.dart';
import 'package:my_app/common/Network.dart';
import 'package:provider/provider.dart';

import '../l10n/localization_intl.dart';
import '../models/access.dart';
import '../states/profile_change_notifier.dart';

class ItineraryRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ItineraryRouteState();
}

class ItineraryRouteState extends State<ItineraryRoute> {
  late UserModel userModel;
  List<Access> _accessList = [];

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    getAccessByPhone();
  }

  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.itinerary)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _accessList.isEmpty
            ? Container(
                padding: const EdgeInsets.all(10),
                child: const Text('暂无行程数据', style: TextStyle(fontSize: 16)),
              )
            : ListView(
                children: _accessList.map((Access access) => AccessWidget(access: access)).toList(),
              ),
      ),
    );
  }

  Future<void> getAccessByPhone() async {
    List<Access>? list = await Network(context).getAccessByPhone(userModel.user!.userPhone);
    setState(() {
      _accessList = list ?? [];
    });
  }
}

class AccessWidget extends StatelessWidget {
  final Access access;

  const AccessWidget({super.key, required this.access});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(
        "${access.accessTime}   ${access.district?.communityName}${access.district?.districtName}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

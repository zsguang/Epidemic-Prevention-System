import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/common/Network.dart';
import 'package:my_app/common/funs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../l10n/localization_intl.dart';
import '../models/user.dart';
import '../states/profile_change_notifier.dart';

class AvtarRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(appBar: AppBar(title: Text(gm.avatar)), body: AvtarPage());
  }
}

class AvtarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AvtarPageState();
}

class AvtarPageState extends State<AvtarPage> {
  String avtar = "";
  String fileName = "";
  late UserModel userModel;
  late ImageProvider avtarImage;
  late NetworkImage networkImage;

  late GmLocalizations gm;

  void initData(GmLocalizations gm, UserModel userModel) {
    networkImage = NetworkImage("${Network.baseUrl}${userModel.user?.avatar}");
    setState(() {
      avtarImage = networkImage;
    });
  }

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    avtarImage = NetworkImage("${Network.baseUrl}${userModel.user?.avatar}");
    // showLog("AvtarRoute initState", "${Network.baseUrl}${userModel.user?.avatar}");
  }

  @override
  Widget build(BuildContext context) {
    gm = GmLocalizations.of(context);
    var size = MediaQuery.of(context).size;
    // showLog("AvtarRoute", "size=$size");
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Image(
              image: avtarImage,
              width: min(size.width, size.height) - 180,
              // height: 150,
              errorBuilder: (buildContext, widget, imageChunkEvent) =>
                  Image.asset('assets/images/defaultUser.png', scale: 0.5),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2.3).clamp(150, 180),
                child: FilledButton(
                  onPressed: () => _changeAvtar(context, gm),
                  child: Text(gm.changeAvtar, style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2.3).clamp(150, 200),
                child: FilledButton(
                  onPressed: _upLoadImage,
                  child: Text(gm.confirmReplacement, style: TextStyle(fontSize: 20)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _changeAvtar(BuildContext context, GmLocalizations gm) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text(gm.shootPhone),
                onTap: () {
                  requestCameraPermission();
                  _getImage(true);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(gm.selectPhone),
                onTap: () {
                  requestStoragePermission();
                  _getImage(false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _upLoadImage() async {
    // showLog("AvtarRoute", "fileName=$fileName");
    if (fileName == "") {
      showToast(gm.noChoiceImage);
      return;
    }
    String? image = await Network(context).uploadImage(File(fileName));
    // showLog("AvtarRoute", "image=$image");
    if (image != null) {
      userModel.user?.avatar = image;
      User? user = await Network(context).updateUser(userModel.user);
      if (user != null) Provider.of<UserModel>(context, listen: false).user = user;
      showToast(gm.successChangeAvtar);
    }
  }

  Future<void> _getImage(bool isTakePhoto) async {
    // requestCameraPermission();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: isTakePhoto ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      // 处理拍照的操作
      showLog("AvtarRoute _shootImage", "pickedFile.path=${pickedFile.path}");
      setState(() {
        avtarImage = FileImage(File(pickedFile.path));
      });
      fileName = pickedFile.path;
      Navigator.pop(context);
    }
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.denied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('提示'),
          content: Text('请允许应用程序访问您的相册。'),
          actions: [
            TextButton(
              child: Text('确认'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.denied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('提示'),
          content: Text('请允许应用程序访问您的相机。'),
          actions: [
            TextButton(
              child: Text('确认'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
  }
}

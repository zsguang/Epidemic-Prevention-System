import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../l10n/localization_intl.dart';
import '../models/bulletin.dart';
import '../models/index.dart';
import '../models/result.dart';
import '../states/profile_change_notifier.dart';
import 'funs.dart';
export 'package:dio/dio.dart' show DioError;

class Network {
  static const String baseUrl = 'http://192.168.137.1:9090';
  BuildContext context;
  late Options _options;

  static Dio dio = Dio(BaseOptions(
    // baseUrl: 'http://localhost:9090',
    baseUrl: baseUrl,

    connectTimeout: Duration(seconds: 10),
    sendTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    // headers: {
    //   HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
    //       "application/vnd.github.symmetra-preview+json",
    // },
  ));

  Dio dioCov = Dio(BaseOptions(
    baseUrl: 'https://lab.isaaclin.cn/nCoV/api',
    connectTimeout: Duration(seconds: 100),
    sendTimeout: Duration(seconds: 100),
    receiveTimeout: Duration(seconds: 100),
    maxRedirects: 10,
    followRedirects: false, //防止因错误重定向而没有得到完整数据
  ));

  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。
  Network(this.context) {
    _options = Options(extra: {"context": context});
  }

  static void init() {
    // 设置用户token（可能为null，代表未登录）
    // dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    // // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    // if (!Global.isRelease) {
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     // client.findProxy = (uri) {
    //     //   return 'PROXY 192.168.50.154:8888';
    //     // };
    //     //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //   };
    // }
  }

  // 登录接口，登录成功后返回用户信息
  Future<ResultObject?> login(String phone, String pwd) async {
    var user = User();
    user.userPhone = phone;
    user.password = pwd;
    var response = await dio.post("/user/login", data: user.toJson()).catchError((error) {
      showToast(GmLocalizations.of(context).networkError);
    });

    showLog("Network login", "response.data = ${response.data}");
    return ResultObject.fromJson(response.data);
  }

  Future<User?> getUserInfo(User? user) async {
    if (user == null) return null;

    var response = await dio.post("/user/login", data: user.toJson()).catchError((error) {
      showToast(GmLocalizations.of(context).networkError);
    });

    // showLog("Network getUserInfo", "response.data = ${response.data}");
    var data = ResultObject.fromJson(response.data).data;
    if (data == null) return null;
    User res = User.fromJson(data);
    return res;
  }

  Future<User?> updateUser(User? user) async {
    if (user == null) return null;
    Response response = await dio.put("/user", data: user.toJson());
    ResultObject resultObject = ResultObject.fromJson(response.data);
    if (resultObject.code == "0" && resultObject.data != null) {
      return User.fromJson(resultObject.data!);
    }
    return null;
  }

  Future<bool> addUser(User user) async {
    Response response = await dio.post("/user", data: user.toJson());
    Result result = Result.fromJson(response.data);
    if (result.code == '-1') {
      showToast(result.msg);
      return false;
    }
    if (result.code == '0') return true;
    return false;
  }

  Future<bool> authentic(User user) async {
    Response response = await dio.put("/user/authenticate", data: user.toJson());
    // showLog("Network authentic", "result.data = ${response.toString()}");
    Result result = Result.fromJson(response.data);
    if (result.code == '-1') {
      showToast(result.msg);
      return false;
    } else {
      User resultUser = User.fromJson(result.data);
      Provider.of<UserModel>(context, listen: false).user = resultUser;
      return true;
    }
  }

  Future<String?> getCommunityName(String id) async {
    var response = await dio.get(
      "/community/getCommunityName",
      queryParameters: {'communityId': id},
    ).catchError((error) => showToast(GmLocalizations.of(context).networkError));

    // showLog("Network getCommunityName", "response.data = ${response.data}");
    ResultString result = ResultString.fromJson(response.data);
    String? data = result.data;
    return data;
  }

  Future<String?> uploadImage(File imageFile) async {
    String fileName = imageFile.path.split('/').last;
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });
    Response response = await dio.post("$baseUrl/images/upload", data: data).catchError((error) {
      showToast('图像上传失败');
      showLog('Network uploadImage', error.toString());
    });
    ResultString result = ResultString.fromJson(response.data);
    if (result.code == "0") {
      return result.data;
    } else {
      return null;
    }
  }

  Future<Map<String, Province>> getProvinceCount() async {
    var response = await dioCov.get(
      '/area',
      queryParameters: {'country': '中国'},
    ).catchError((error) => showToast('数据加载失败'));

    Map<String, Province> map = {};
    // try {
    Country country = Country.fromJson(response.data);
    print(country);
    for (int i = 0; i < country.results.length; i++) {
      if (Province.provinces.contains(country.results[i].provinceName)) {
        map.putIfAbsent(country.results[i].provinceShortName!, () => country.results.elementAt(i));
      }
    }
    // } catch (e) {
    //   showLog("Network getProvinceCount", "数据解析错误：${e.toString()}");
    // }
    // print("1---${map.toString()}");
    return map;
  }

  Future<List<News>?> getNews(int page) async {
    var response = await dioCov.get(
      '/news',
      queryParameters: {'page': page},
    ).catchError((error) => showToast('新闻数据加载失败'));

    var data = NewsObject.fromJson(response.data);
    List<News> res = [];
    data.results?.forEach((news) {
      // if (news.sourceUrl != null && news.sourceUrl != '') {
      //   res.add(news);
      // }
      if (news.summary != null && news.summary != '' && news.summary!.trim().isNotEmpty) {
        res.add(news);
      }
    });
    return res;
  }

  Future<PageObject?> findPage(int pageNum, int pageSize, String userPhone, String userName, String userIdCard,
      String userCommunity, String health, String manager) async {
    var response = await dio.get('/user/page', queryParameters: {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'userPhone': userPhone,
      'userName': userName,
      'userIdCard': userIdCard,
      'userCommunity': userCommunity,
      'health': health,
      'manager': manager
    });
    try {
      // print("\n----response=${response.data}\n");
      ResultObject resultObject = ResultObject.fromJson(response.data);
      var page = PageObject.fromJson(resultObject.data as Map<String, dynamic>);
      // List<User>? users = (page.records)?.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
      return page;
    } catch (e) {
      showLog("Network findPage", e.toString());
      return null;
    }
  }

  Future<List<User>?> getAllUser(
    String userPhone,
    String userName,
    String userIdCard,
    String community,
    String health,
    String manager,
  ) async {
    var response = await dio.get('/user/all', queryParameters: {
      'userPhone': userPhone,
      'userName': userName,
      'userIdCard': userIdCard,
      'address': community,
      'health': health,
      'manager': manager
    });
    try {
      // print("\n----response=${response.data}\n");
      Result result = Result.fromJson(response.data);
      List<User>? users =
          (result.data as List<dynamic>?)?.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
      return users;
    } catch (e) {
      showLog("Network getAllUser", e.toString());
      return null;
    }
  }

  Future<List<Community>?> getCommunityList(String search) async {
    var response = await dio.get('/community/all', queryParameters: {
      'search': search,
    }).catchError((onError) {
      showToast(GmLocalizations.of(context).networkError);
    }, test: (error) => error is int && error >= 400);
    // showLog('Network getCommunityList', '${response.data}');
    Result result = Result.fromJson(response.data);
    List<Community>? communities =
        (result.data as List<dynamic>?)?.map((e) => Community.fromJson(e as Map<String, dynamic>)).toList();
    return communities;
  }

  Future<List<District>?> getDistrictList(String search) async {
    var response = await dio.get('/district/all', queryParameters: {
      'search': search,
    }).catchError((onError) {
      showToast(GmLocalizations.of(context).networkError);
    });
    // showLog('Network getCommunityList', '${response.data}');
    Result result = Result.fromJson(response.data);
    List<District>? districts =
        (result.data as List<dynamic>?)?.map((e) => District.fromJson(e as Map<String, dynamic>)).toList();
    return districts;
  }

  Future<List<DailyReport>?> getDailyReportList(
    String time,
    String user,
    String address,
    String temperature,
    String coughed,
    String diarrheaed,
    String weaked,
  ) async {
    // print('---time=$time');
    var response = await dio.get('/dailyReport/all', queryParameters: {
      'time': time,
      'user': user,
      'address': address,
      'temperature': temperature,
      'coughed': coughed,
      'diarrheaed': diarrheaed,
      'weaked': weaked
    }).catchError((onError) {
      showToast(GmLocalizations.of(context).networkError);
    });
    // showLog('Network getDailyReportList', '${response.data}');
    Result result = Result.fromJson(response.data);
    List<DailyReport>? dailyReports =
        (result.data as List<dynamic>?)?.map((e) => DailyReport.fromJson(e as Map<String, dynamic>)).toList();
    return dailyReports;
  }

  Future<bool> addDistrict(District district) async {
    var response = await dio.post('/district', data: district.toJson());
    // showLog('Network addDistrict', '${response.data}');
    Result result = Result.fromJson(response.data);
    if (result.code == '-1') {
      showToast(result.msg);
      return false;
    } else {
      showToast('添加成功');
      return true;
    }
  }

  Future<bool> addCommunity(Community community) async {
    var response = await dio.post('/community', data: community.toJson());
    showLog('Network addCommunity', '${response.data}');
    Result result = Result.fromJson(response.data);
    if (result.code == '-1') {
      showToast(result.msg);
      return false;
    } else {
      showToast('添加成功');
      return true;
    }
  }

  Future<List<Access>?> getAccessList(
      String time, String user, String community, String district, String outPrince) async {
    // print('----time = $time');
    var response = await dio.get(
      '/access/all',
      queryParameters: {
        'time': time,
        'user': user,
        'community': community,
        'district': district,
        'outPrince': outPrince
      },
    );
    // showLog('Network getAccessList', response.toString());
    Result result = Result.fromJson(response.data);
    List<Access>? list =
        (result.data as List<dynamic>?)?.map((e) => Access.fromJson(e as Map<String, dynamic>)).toList();
    return list;
  }

  Future<List<Bulletin>?> getBulletinList(String time, String title, String author, String user) async {
    var response = await dio.get(
      '/notice/all',
      queryParameters: {
        'time': time,
        'title': title,
        'author': author,
        'user': user,
      },
    );
    // showLog('Network getBulletinList', response.toString());
    Result result = Result.fromJson(response.data);
    List<Bulletin>? list =
        (result.data as List<dynamic>?)?.map((e) => Bulletin.fromJson(e as Map<String, dynamic>)).toList();
    return list;
  }

  Future<Bulletin?> getLatestBulletin() async {
    var response = await dio.get('/notice/latest');
    // showLog('Network getLatestBulletin', response.toString());
    Result result = Result.fromJson(response.data);
    if (result.code == '0' && result.data != null) {
      Bulletin? bulletin = Bulletin.fromJson(result.data);
      return bulletin;
    }
    return null;
  }

  Future<bool> addBulletin(Bulletin bulletin) async {
    var response = await dio.post('/notice', data: bulletin.toJson()).catchError((onError) {
      showToast(GmLocalizations.of(context).networkError);
    });
    // showLog('Network addBulletin', '${response.data}');
    Result result = Result.fromJson(response.data);
    if (result.code == '-1') {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> editBulletin(Bulletin bulletin) async {
    var response = await dio.put('/notice', data: bulletin.toJson()).catchError((onError) {
      showToast(GmLocalizations.of(context).networkError);
    });
    // showLog('Network addBulletin', '${response.data}');
    Result result = Result.fromJson(response.data);
    if (result.code == '-1') {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> deleteBulletin(List<Bulletin> bulletins) async {
    var response = await dio.put('/notice/delete', data: jsonEncode(bulletins)).catchError((err) {
      showToast(GmLocalizations.of(context).networkError);
    });
    showLog('Network deleteBulletin', '${response.data}');
    Result result = Result.fromJson(response.data);
    if (result.code == '-1') {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> addAccess(Access access) async {
    var response = await dio.post('/access', data: access.toJson()).catchError((onError) {
      showToast(GmLocalizations.of(context).networkError);
    });
    showLog('Network addAccess', '${response.data}');
    Result result = Result.fromJson(response.data);
    if (result.code == '-1') {
      // showToast(result.msg);
      return false;
    } else {
      // showToast('扫码成功');
      return true;
    }
  }

  Future<bool> addDailyReport(DailyReport dailyReport) async {
    var response = await dio.post('/dailyReport', data: dailyReport.toJson()).catchError((onError) {
      showToast(GmLocalizations.of(context).networkError);
    });
    showLog('Network addDailyReport', '${response.data}');
    Result result = Result.fromJson(response.data);
    if (result.code == '-1') {
      // showToast(result.msg);
      return false;
    } else {
      // showToast('扫码成功');
      return true;
    }
    return false;
  }

  Future<List<Access>?> getAccessByPhone(String phone) async {
    var response = await dio.get('/access/phone', queryParameters: {'phone': phone}).catchError((onError) {
      showLog('Network getAccessByPhone', '${onError.toString()}');
    });
    // showLog('Network getAccessByPhone', '${response.toString()}');
    Result result = Result.fromJson(response.data);
    List<Access>? accessList =
        (result.data as List<dynamic>?)?.map((e) => Access.fromJson(e as Map<String, dynamic>)).toList();
    return accessList;
  }

  Future<List<User>?> getAllPredict(String user) async {
    var response = await dio.get('/predict/all', queryParameters: {'defaultUser': user}).catchError((onError) {
      showLog('Network getAllPredict', '${onError.toString()}');
    });
    // showLog('Network getAllPredict', '${response.toString()}');
    Result result = Result.fromJson(response.data);
    List<User>? accessList =
        (result.data as List<dynamic>?)?.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    return accessList;
  }
}

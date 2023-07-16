import 'package:flutter/foundation.dart';

class APIs{

  late String _protocol, _domain, baseUrl;

  //auth apis
  String login = "/api/v1/auth/login";

  //user apis
  String getInfo = "/api/v1/user/get/info";

  //product apis


  //channel apis
  String getChannels = "/api/v1/channel/get";
  String addChannel = "/api/v1/channel/add";

  APIs(){
    if(kDebugMode){
      _protocol = "http://";
      _domain = "localhost:8080";
    }else if(kProfileMode || kReleaseMode){
      _protocol = "http://";
      _domain = "localhost:8080";
    }
    baseUrl = _protocol + _domain;
  }
}
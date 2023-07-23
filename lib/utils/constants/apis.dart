import 'package:flutter/foundation.dart';

class APIs{

  late String _protocol, _domain, baseUrl;

  //auth apis
  String login = "/api/v1/auth/login";

  //user apis
  String getInfo = "/api/v1/user/get/info";
  String getUsers = "/api/v1/user/get";
  String addUser = "/api/v1/user/add";
  String updateUser = "/api/v1/user/update";
  String deleteUser = "/api/v1/user/delete/";

  //product apis
  String getProducts = "/api/v1/product/get";
  String addProduct = "/api/v1/product/add";
  String updateProduct = "/api/v1/product/update";
  String assignProduct = "/api/v1/product/assign";
  String deleteProduct = "/api/v1/product/delete/";

  //channel apis
  String getChannels = "/api/v1/channel/get";
  String addChannel = "/api/v1/channel/add";
  String updateChannel = "/api/v1/channel/update";
  String deleteChannel = "/api/v1/channel/delete/";

  //redirect apis
  String redirect = "/api/v1/redirect";

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
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';

import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/data/repositories/session_manager.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';
import 'package:kynaara_frontend/utils/constants/warnings_messages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenController{
  User? user;
  LoaderBloc loaderBloc = LoaderBloc();
  MessageBloc messageBloc = MessageBloc("");
  SessionManager sessionManager = SessionManager();

  ApiService apiService = ApiService();
  APIs apIs = APIs();

  late Function logoutCallback;

  HomeScreenController(Function callback){
    logoutCallback = callback;
  }

  void getInfo(Function callback) async {
    //loader is not loading
    if(!loaderBloc.state){
      //start loading
      loaderBloc.add(LoaderLoading());

      try{
        //getting response
        Response response = await apiService.execute(apIs.baseUrl + apIs.getInfo, ApiMethod.get);

        //validate response
        if(response != null){
          if(response.statusCode >= 500){
            setMessage(CustomWarningsMessages.error5XX);
          }else if(response.statusCode == 401){
            logoutCallback();
          }else{
            print(response.body);
            Map<String, dynamic> json = jsonDecode(response.body);
            if(json['success']){
              //main network response
              user = User.fromJson(json['data']);
              callback();
            }else{
              setMessage(json['message']);
            }
          }
        }else{
          setMessage(CustomWarningsMessages.unknownErrorOccured);
        }

      }catch(e){
        if (kDebugMode) {
          print(e);
        }
        setMessage(CustomWarningsMessages.unknownErrorOccured);
      }

      //stop loading
      loaderBloc.add(LoaderStopped());
    }
  }

  void logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sessionManager.saveToken(sharedPreferences, "");
  }

  void setMessage(String message) async {
    messageBloc.add(MessageReceived(message));
    await Future.delayed(const Duration(seconds: 0));
    messageBloc.add(MessageClear());
  }
}
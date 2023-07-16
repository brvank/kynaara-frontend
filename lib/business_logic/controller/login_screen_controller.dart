import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/controller/message_controller.dart';
import 'package:kynaara_frontend/data/repositories/session_manager.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';
import 'package:kynaara_frontend/utils/constants/warnings_messages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenController{

  LoaderBloc loaderBloc = LoaderBloc();
  MessageBloc messageBloc = MessageBloc("");
  SessionManager sessionManager = SessionManager();

  ApiService apiService = ApiService();
  APIs apIs = APIs();

  void login(String userName, String password, Function callback) async {
    //loader is not loading
    if(!loaderBloc.state){
      //start loading
      loaderBloc.add(LoaderLoading());

      try{
        //create api request for user login
        var body = jsonEncode(<String, String>{
          "user_name": userName,
          "password": password
        });

        //getting response
        Response response = await apiService.execute(apIs.baseUrl + apIs.login, ApiMethod.post, body: body);

        //validate response
        if(response != null){
          if(response.body == null || response.statusCode >= 500){
            setMessage(CustomWarningsMessages.error5XX);
          }else{
            print(response.body);
            Map<String, dynamic> json = jsonDecode(response.body);
            if(json['success']){
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sessionManager.saveToken(sharedPreferences, json['data']['token']);
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

  void setMessage(String message) async {
    messageBloc.add(MessageReceived(message));
    await Future.delayed(const Duration(seconds: 0));
    messageBloc.add(MessageClear());
  }

}
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/data/model/channel.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/data/repositories/session_manager.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';
import 'package:kynaara_frontend/utils/constants/warnings_messages.dart';

class AdminPageController{
  User? user;
  LoaderBloc channelLoaderBloc = LoaderBloc();
  MessageBloc messageBloc = MessageBloc("");
  SessionManager sessionManager = SessionManager();

  ApiService apiService = ApiService();
  APIs apIs = APIs();

  late Function logoutCallback;

  AdminPageController(Function callback){
    this.logoutCallback = callback;
  }

  void setMessage(String message) async {
    messageBloc.add(MessageReceived(message));
    await Future.delayed(const Duration(seconds: 0));
    messageBloc.add(MessageClear());
  }
}
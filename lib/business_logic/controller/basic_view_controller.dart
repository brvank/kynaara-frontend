import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/data/model/channel.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';
import 'package:kynaara_frontend/utils/constants/warnings_messages.dart';

class BasicViewController {
  LoaderBloc loaderBloc = LoaderBloc();
  APIs apIs = APIs();
  MessageBloc messageBloc = MessageBloc("");
  ApiService apiService = ApiService();
  List<Channel> channels = [];

  late Function logoutCallback;

  BasicViewController(Function logoutCallback) {
    logoutCallback = logoutCallback;
  }

  //get channels
  void getChannels(int start, int size, String? q, Function callback) async {
    //loader is not loading
    if (!loaderBloc.state) {
      //start loading
      loaderBloc.add(LoaderLoading());

      try {
        String url = apIs.baseUrl + apIs.getChannels;

        if (q == null) {
          q = "";
        }

        url = "$url?start=$start&size=$size&q=$q";

        //getting response
        Response response = await apiService.execute(url, ApiMethod.get);

        //validate response
        if (response != null) {
          if (response.statusCode >= 500) {
            setMessage(CustomWarningsMessages.error5XX);
          } else if (response.statusCode == 401) {
            logoutCallback();
          } else {
            print(response.body);
            Map<String, dynamic> json = jsonDecode(response.body);
            if (json['success']) {
              //main network response
              for (int i = 0; i < json['data']['result'].length; i++) {
                channels.add(Channel.fromJson(json['data']['result'][i]));
              }
              callback(start, channels.length, json['data']['count']);
            } else {
              setMessage(json['message']);
            }
          }
        } else {
          setMessage(CustomWarningsMessages.unknownErrorOccured);
        }
      } catch (e) {
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
    await Future.delayed(Duration.zero);
    messageBloc.add(MessageClear());
  }
}

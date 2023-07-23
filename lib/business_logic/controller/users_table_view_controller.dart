import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';
import 'package:kynaara_frontend/utils/constants/warnings_messages.dart';

class UsersTableViewController {
  LoaderBloc loaderBloc = LoaderBloc();
  APIs apIs = APIs();
  MessageBloc messageBloc = MessageBloc("");
  ApiService apiService = ApiService();
  List<User> users = [];

  late Function logoutCallback;

  UsersTableViewController(Function logoutCallback) {
    logoutCallback = logoutCallback;
  }

  //get users
  void getUsers(int start, int size, String? q, Function callback) async {
    //loader is not loading
    if (!loaderBloc.state) {
      //start loading
      loaderBloc.add(LoaderLoading());

      try {
        String url = apIs.baseUrl + apIs.getUsers;

        if (q == null) {
          q = "";
        }

        url = "$url?start=$start&size=$size&userName=$q";

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
              users = [];
              for (int i = 0; i < json['data']['result'].length; i++) {
                users.add(User.fromJson(json['data']['result'][i]));
              }
              callback(start, start + users.length, json['data']['count']);
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

  Future<bool> addUser(User user) async {
    bool result = false;

    //loader is not loading
    if (!loaderBloc.state) {
      //start loading
      loaderBloc.add(LoaderLoading());

      try {

        Map<String, Object> userMap = Map();
        userMap['full_name'] = user.name;
        userMap['user_name'] = user.userName;
        userMap['email'] = user.email;
        userMap['password'] = user.password;
        userMap['user_level'] = user.userLevel;


        //getting response
        Response response = await apiService.execute(apIs.baseUrl + apIs.addUser, ApiMethod.post, body: jsonEncode(userMap));

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
              setMessage(json['message']);
              result = true;
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

    return result;
  }

  Future<bool> updateUser(User user) async {
    bool result = false;

    //loader is not loading
    if (!loaderBloc.state) {
      //start loading
      loaderBloc.add(LoaderLoading());

      try {

        Map<String, Object> userMap = Map();
        userMap['user_id'] = user.id;
        userMap['full_name'] = user.name;
        userMap['email'] = user.email;
        userMap['user_level'] = user.userLevel;

        //getting response
        Response response = await apiService.execute(apIs.baseUrl + apIs.updateUser, ApiMethod.put, body: jsonEncode(userMap));

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
              setMessage(json['message']);
              result = true;
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

    return result;
  }

  Future<bool> deleteUser(int id) async {
    bool result = false;

    //loader is not loading
    if (!loaderBloc.state) {
      //start loading
      loaderBloc.add(LoaderLoading());

      try {

        //getting response
        Response response = await apiService.execute(apIs.baseUrl + apIs.deleteUser + id.toString(), ApiMethod.delete);

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
              setMessage(json['message']);
              result = true;
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

    return result;
  }

  void setMessage(String message) async {
    messageBloc.add(MessageReceived(message));
    await Future.delayed(Duration.zero);
    messageBloc.add(MessageClear());
  }
}

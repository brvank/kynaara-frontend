import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/data/model/product.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';
import 'package:kynaara_frontend/utils/constants/warnings_messages.dart';

class ProductsTableViewController {
  LoaderBloc loaderBloc = LoaderBloc();
  APIs apIs = APIs();
  MessageBloc messageBloc = MessageBloc("");
  ApiService apiService = ApiService();
  List<Product> products = [];

  late Function logoutCallback;

  ProductsTableViewController(Function logoutCallback) {
    logoutCallback = logoutCallback;
  }

  //get products
  void getProducts(int start, int size, String? q, Function callback) async {
    //loader is not loading
    if (!loaderBloc.state) {
      //start loading
      loaderBloc.add(LoaderLoading());

      try {
        String url = apIs.baseUrl + apIs.getProducts;

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
              products = [];
              for (int i = 0; i < json['data']['result'].length; i++) {
                products.add(Product.fromJson(json['data']['result'][i]));
              }
              callback(start, start + products.length, json['data']['count']);
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

  Future<bool> addProduct(Product product) async {
    bool result = false;

    //loader is not loading
    if (!loaderBloc.state) {
      //start loading
      loaderBloc.add(LoaderLoading());

      try {

        Map<String, Object> productMap = Map();
        productMap['channel_id'] = product.channelId;
        productMap['link'] = product.link;
        productMap['image_link'] = product.imageLink;

        //getting response
        Response response = await apiService.execute(apIs.baseUrl + apIs.addProduct, ApiMethod.post, body: jsonEncode(productMap));

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

  Future<bool> updateProduct(Product product) async {
    bool result = false;

    //loader is not loading
    if (!loaderBloc.state) {
      //start loading
      loaderBloc.add(LoaderLoading());

      try {

        Map<String, Object> productMap = Map();
        productMap['product_id'] = product.id;
        productMap['channel_id'] = product.channelId;
        productMap['link'] = product.link;
        productMap['image_link'] = product.imageLink;

        //getting response
        Response response = await apiService.execute(apIs.baseUrl + apIs.updateProduct, ApiMethod.put, body: jsonEncode(productMap));

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

  Future<bool> deleteProduct(int id) async {
    bool result = false;

    //loader is not loading
    if (!loaderBloc.state) {
      //start loading
      loaderBloc.add(LoaderLoading());

      try {

        //getting response
        Response response = await apiService.execute(apIs.baseUrl + apIs.deleteProduct + id.toString(), ApiMethod.delete);

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

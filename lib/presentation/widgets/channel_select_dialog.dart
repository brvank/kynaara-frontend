import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kynaara_frontend/data/model/channel.dart';
import 'package:kynaara_frontend/presentation/widgets/custom_button.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';

class ChannelSelectDialog extends StatefulWidget {
  const ChannelSelectDialog({super.key});

  @override
  State<ChannelSelectDialog> createState() => _ChannelSelectDialogState();
}

class _ChannelSelectDialogState extends State<ChannelSelectDialog> {
  TextEditingController _channelNameTextEditingController =
      TextEditingController();
  bool loading = false;
  bool error = false;

  late Timer? timer;
  List<Channel> channels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timer = null;

    _channelNameTextEditingController.addListener(() {
      if (_channelNameTextEditingController.text.isNotEmpty) {
        resetTimer();
      } else {
        if (timer != null) {
          if (timer!.isActive) {
            timer!.cancel();
          }
        }
      }
    });
  }

  void resetTimer() {
    error = false;
    loading = false;
    setState(() {});
    if (timer != null) {
      if (timer!.isActive) {
        timer!.cancel();
      }
    }
    timer = Timer(Duration(milliseconds: 1500), () {
      setState(() {
        getChannels();
      });
    });
  }

  void getChannels() async {
    ApiService apiService = ApiService();
    APIs apIs = APIs();

    error = false;
    loading = true;
    try {
      var response = await apiService.execute(
          "${apIs.baseUrl}${apIs.getChannels}?start=0&size=3&q=${_channelNameTextEditingController.text}",
          ApiMethod.get);
      var jsonArray = jsonDecode(response.body)['data']['result'];

      channels = [];

      for (int i = 0; i < jsonArray.length; i++) {
        channels.add(Channel.fromJson(jsonArray[i]));
      }
    } catch (e) {
      error = true;
    }

    loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(8),
        width: MediaQuery.sizeOf(context).width * 0.6,
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: TextField(
                autofocus: true,
                cursorColor: Colors.deepOrange,
                controller: _channelNameTextEditingController,
                decoration: const InputDecoration(
                    labelText: "Search Channel",
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.orangeAccent)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.orangeAccent))),
                enabled: !loading,
              ),
            ),
            loading
                ? const Expanded(
                    flex: 1,
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )),
                  )
                : (error
                    ? const Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "Something went wrong!",
                          style: TextStyle(
                              color: Colors.brown, fontWeight: FontWeight.bold),
                        )),
                      )
                    : Expanded(
                        flex: 1,
                        child: ListView.builder(
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(channels[i].name),
                              onTap: () {
                                returnChannel(channels[i]);
                              },
                            );
                          },
                          itemCount: channels.length,
                        ),
                      )),
            CustomButton(
                text: "Cancel",
                callback: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  void returnChannel(Channel channel) {
    Navigator.pop(context, channel);
  }
}

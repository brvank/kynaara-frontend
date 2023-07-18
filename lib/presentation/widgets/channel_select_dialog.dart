import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kynaara_frontend/data/model/channel.dart';
import 'package:kynaara_frontend/service/network/api_service.dart';
import 'package:kynaara_frontend/utils/constants/apis.dart';

class ChannelSelectDialog extends StatefulWidget {
  const ChannelSelectDialog({super.key});

  @override
  State<ChannelSelectDialog> createState() => _ChannelSelectDialogState();
}

class _ChannelSelectDialogState extends State<ChannelSelectDialog> {

  TextEditingController _channelNameTextEditingController = TextEditingController();
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
      if(_channelNameTextEditingController.text.isNotEmpty){
        resetTimer();
      }else{
        if(timer != null){
          if(timer!.isActive){
            timer!.cancel();
          }
        }
      }
    });
  }

  void resetTimer(){
    error = false;
    loading = false;
    setState(() {

    });
    if(timer != null){
      if(timer!.isActive){
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
    try{
      var response = await apiService.execute("${apIs.baseUrl}${apIs.getChannels}?start=0&size=3&q=${_channelNameTextEditingController.text}", ApiMethod.get);
      var jsonArray = jsonDecode(response.body)['data']['result'];

      for(int i=0;i<jsonArray.length;i++){
        channels.add(Channel.fromJson(jsonArray[i]));
      }

    }catch(e){
      error = true;
    }

    loading = false;

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Select Channel"),
          TextField(
            decoration: InputDecoration(
              hintText: "Search Channel"
            ),
            controller: _channelNameTextEditingController,
          ),
          loading ? CircularProgressIndicator() : (error ? Text("Something went wrong!") : Expanded(
            flex: 1,
            child: ListView.builder(itemBuilder: (context, i){
              return ListTile(
                title: Text(channels[i].name),
                onTap: (){
                  returnChannel(channels[i]);
                },
              );
            }, itemCount: channels.length,),
          ))
        ],
      ),
    );
  }

  void returnChannel(Channel channel){
    Navigator.pop(context, channel);
  }
}

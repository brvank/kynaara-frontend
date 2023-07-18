import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/business_logic/controller/channels_table_view_controller.dart';
import 'package:kynaara_frontend/data/model/channel.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/widgets/channel_dialog.dart';
import 'package:kynaara_frontend/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';

class ChannelsTableView extends StatefulWidget {
  final User user;
  const ChannelsTableView({Key? key, required this.user}) : super(key: key);

  @override
  State<ChannelsTableView> createState() => _ChannelsTableViewState();
}

class _ChannelsTableViewState extends State<ChannelsTableView> {
  late ChannelsTableViewController _channelsTableController;

  int start = 0, size = 2, end = 0, total = 0;

  TextEditingController channelNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _channelsTableController = ChannelsTableViewController(() {
      logoutUser(context);
    });

    getChannels();
  }

  void getChannels() {
    _channelsTableController.getChannels(
        start, size, channelNameController.text, (start, end, total) {
      this.start = start;
      this.end = end;
      this.total = total;

      setState(() {
        Future.delayed(Duration.zero).then((value){
          if(_channelsTableController.channels.isEmpty){
            getPrev();
          }
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoaderBloc>(
            create: (context) {
              return _channelsTableController.loaderBloc;
            },
          ),
          BlocProvider<MessageBloc>(
            create: (context) {
              return _channelsTableController.messageBloc;
            },
          )
        ],
        child: BlocConsumer<MessageBloc, String>(
          listener: (context, state) {
            if (state.isNotEmpty) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state),
                  duration: const Duration(seconds: 2),
                ));
              }
            }
          },
          builder: (context, state) {
            return BlocBuilder<LoaderBloc, bool>(builder: (context, state) {
              if (state == true) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.all(8),
                  color: Colors.blue,
                  child: Column(
                    children: [
                      //all options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                addChannelDialog();
                              },
                              child: Text("Add Channel"))
                        ],
                      ),

                      //all headings
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("S.No.")),
                          Expanded(flex: 2, child: Text("Name")),
                          Expanded(flex: 2, child: Text("Link")),
                          Expanded(flex: 2, child: Text("Date of Creation")),
                          Expanded(flex: 1, child: Text("")),
                          Expanded(flex: 1, child: Text("")),
                        ],
                      ),

                      //all channels
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  _channelsTableController.channels.length,
                              itemBuilder: (context, i) {
                                return Row(
                                  children: [
                                    Expanded(
                                        flex: 1, child: Text("${i+1}")),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_channelsTableController
                                            .channels[i].name)),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_channelsTableController
                                            .channels[i].link)),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_channelsTableController
                                            .channels[i].creationDate)),
                                    Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          child: Text("Edit"),
                                          onPressed: () {
                                            updateChannelDialog(_channelsTableController.channels[i]);
                                          },
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          child: Text("Delete"),
                                          onPressed: () {
                                            deleteChannelDialog(_channelsTableController.channels[i].id);
                                          },
                                        )),
                                  ],
                                );
                              })),
                      Row(
                        children: [
                          TextButton(
                            child: Text("Refresh"),
                            onPressed: () {
                              getChannels();
                            },
                          ),
                          TextButton(
                            child: Text("Prev"),
                            onPressed: () {
                              getPrev();
                            },
                          ),
                          Text("$end/$total"),
                          TextButton(
                            child: Text("Next"),
                            onPressed: () {
                              getNext();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
            });
          },
        ));
  }

  void getPrev(){
    if(start != 0){
      if((start - size) >= 0){
        start = start - size;

        getChannels();
      }
    }
  }

  void getNext(){
    if(end <= total && total != 0){
      if((start + size) < total){
        start = start + size;

        getChannels();
      }
    }
  }

  void addChannelDialog() {
    Channel channel = Channel(
        id: -1,
        creatorId: -1,
        link: "",
        logoLink: "",
        name: "",
        creationDate: "");

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ChannelDialog(
              callback: (Channel channel) async {
                bool result =
                    await _channelsTableController.addChannel(channel);
                await Future.delayed(Duration.zero);
                if (result) {
                  getChannels();
                }
                return result;
              },
              edit: false,
              channel: channel);
        });
  }

  void updateChannelDialog(Channel channel){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return ChannelDialog(
          callback: (Channel channel) async {
            bool result = await _channelsTableController.updateChannel(channel);
            await Future.delayed(Duration.zero);
            if(result){
              getChannels();
            }

            return result;
          },
          edit: true,
          channel: channel,
        );
      }
    );
  }

  void deleteChannelDialog(int id) async {
    bool? result = await showDialog(
      context: context,
      builder: (context){
        return DeleteConfirmationDialog();
      }
    );

    if(result != null && result == true){
      bool result = await _channelsTableController.deleteChannel(id);
      await Future.delayed(Duration.zero);
      if(result){
        getChannels();
      }
    }
  }
}

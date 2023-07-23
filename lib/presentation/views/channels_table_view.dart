import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/business_logic/controller/channels_table_view_controller.dart';
import 'package:kynaara_frontend/data/model/channel.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/widgets/channel_dialog.dart';
import 'package:kynaara_frontend/presentation/widgets/custom_button.dart';
import 'package:kynaara_frontend/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:kynaara_frontend/utils/constants/ui_text_constants.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';

class ChannelsTableView extends StatefulWidget {
  final User user;
  const ChannelsTableView({Key? key, required this.user}) : super(key: key);

  @override
  State<ChannelsTableView> createState() => _ChannelsTableViewState();
}

class _ChannelsTableViewState extends State<ChannelsTableView> {
  late ChannelsTableViewController _channelsTableController;

  int start = 0, size = Constants.size, end = 0, total = 0;

  TextEditingController _channelNameController = TextEditingController();
  String _channelName = "";

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
        start, size, _channelName, (start, end, total) {
      this.start = start;
      this.end = end;
      this.total = total;

      setState(() {
        Future.delayed(Duration.zero).then((value) {
          if (_channelsTableController.channels.isEmpty) {
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
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      //all options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(flex: 1, child: TextField(
                            controller: _channelNameController,
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: "Channel Name",
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.orangeAccent)),
                            ),
                          ),),
                          CustomButton(
                            text: "Search",
                            callback: () {
                              _channelName = _channelNameController.text;
                              getChannels();
                            },
                          ),
                          CustomButton(
                            text: "Refresh",
                            callback: () {
                              getChannels();
                            },
                          ),
                          CustomButton(
                              text: "Add Channel",
                              callback: () {
                                addChannelDialog();
                              })
                        ],
                      ),

                      //all headings
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: TableTabs.headerTab(
                                  "S.No.", TabDirection.LEFT)),
                          Expanded(
                              flex: 2,
                              child: TableTabs.headerTab(
                                  "Name", TabDirection.MID)),
                          Expanded(
                              flex: 2,
                              child: TableTabs.headerTab(
                                  "Link", TabDirection.MID)),
                          Expanded(
                              flex: 2,
                              child: TableTabs.headerTab(
                                  "Date of Creation", TabDirection.MID)),
                          Expanded(
                              flex: 1,
                              child: TableTabs.headerTab("", TabDirection.MID)),
                          Expanded(
                              flex: 1,
                              child:
                                  TableTabs.headerTab("", TabDirection.RIGHT)),
                        ],
                      ),

                      //all channels
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  _channelsTableController.channels.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.brown,
                                              width: 0.2))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child:
                                              TableTabs.tableTab("${i + 1}")),
                                      Expanded(
                                          flex: 2,
                                          child: TableTabs.tableTab(
                                              _channelsTableController
                                                  .channels[i].name)),
                                      Expanded(
                                          flex: 2,
                                          child: TableTabs.tableTab(
                                              _channelsTableController
                                                  .channels[i].link)),
                                      Expanded(
                                          flex: 2,
                                          child: TableTabs.tableTab(
                                              _channelsTableController
                                                  .channels[i].creationDate.substring(0, 10))),
                                      Expanded(
                                          flex: 1,
                                          child: TableTabs.buttonTableTab(
                                              "Edit", () {
                                            updateChannelDialog(
                                                _channelsTableController
                                                    .channels[i]);
                                          })),
                                      Expanded(
                                          flex: 1,
                                          child: TableTabs.buttonTableTab(
                                              "Delete", () {
                                            deleteChannelDialog(
                                                _channelsTableController
                                                    .channels[i].id);
                                          })),
                                    ],
                                  ),
                                );
                              })),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            text: "Prev",
                            callback: () {
                              getPrev();
                            },
                            active: (start - size) >= 0,
                          ),
                          Text("$end/$total"),
                          CustomButton(
                            text: "Next",
                            callback: () {
                              getNext();
                            },
                            active: (start + size) < total,
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

  void getPrev() {
    if (start != 0) {
      if ((start - size) >= 0) {
        start = start - size;

        getChannels();
      }
    }
  }

  void getNext() {
    if (end <= total && total != 0) {
      if ((start + size) < total) {
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

  void updateChannelDialog(Channel channel) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ChannelDialog(
            callback: (Channel channel) async {
              bool result =
                  await _channelsTableController.updateChannel(channel);
              await Future.delayed(Duration.zero);
              if (result) {
                getChannels();
              }

              return result;
            },
            edit: true,
            channel: channel,
          );
        });
  }

  void deleteChannelDialog(int id) async {
    bool? result = await showDialog(
        context: context,
        builder: (context) {
          return const DeleteConfirmationDialog();
        });

    if (result != null && result == true) {
      bool result = await _channelsTableController.deleteChannel(id);
      await Future.delayed(Duration.zero);
      if (result) {
        getChannels();
      }
    }
  }
}

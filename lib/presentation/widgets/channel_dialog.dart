import 'package:flutter/material.dart';
import 'package:kynaara_frontend/data/model/channel.dart';

class ChannelDialog extends StatefulWidget {
  final Function callback;
  final bool edit;
  final Channel channel;
  const ChannelDialog(
      {Key? key,
      required this.callback,
      required this.edit,
      required this.channel})
      : super(key: key);

  @override
  State<ChannelDialog> createState() => _ChannelDialogState();
}

class _ChannelDialogState extends State<ChannelDialog> {
  final TextEditingController _channelNameController = TextEditingController(),
      _channelLinkController = TextEditingController(),
      _channelLogoLinkController = TextEditingController();

  bool loading = false;
  bool allGood = false;

  @override
  void initState() {
    super.initState();

    _channelNameController.text = widget.channel.name;
    _channelLinkController.text = widget.channel.link;
    _channelLogoLinkController.text = widget.channel.logoLink;

    checkAllGood();

    _channelNameController.addListener(() {
      checkAllGood();
    });

    _channelLinkController.addListener(() {
      checkAllGood();
    });

    _channelLogoLinkController.addListener(() {
      checkAllGood();
    });
  }

  void checkAllGood() {
    if (_channelLinkController.text.isNotEmpty &&
        _channelLogoLinkController.text.isNotEmpty &&
        _channelNameController.text.isNotEmpty) {
      allGood = true;
    } else {
      allGood = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.6,
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                child: TextField(
                  autofocus: true,
                  cursorColor: Colors.deepOrange,
                  controller: _channelNameController,
                  decoration: const InputDecoration(
                      labelText: "Channel Name",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.orangeAccent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.orangeAccent))),
                  enabled: !loading,
                ),
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Container(
                    margin: const EdgeInsets.all(8),
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.deepOrange,
                      controller: _channelLinkController,
                      decoration: const InputDecoration(
                          labelText: "Channel Link",
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 1, color: Colors.orangeAccent)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.orangeAccent))),
                      enabled: !loading,
                    ),
                  )),
                  Expanded(flex: 1, child: Container(
                    margin: const EdgeInsets.all(8),
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.deepOrange,
                      controller: _channelLogoLinkController,
                      decoration: const InputDecoration(
                          labelText: "Channel Logo Link",
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 1, color: Colors.orangeAccent)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.orangeAccent))),
                      enabled: !loading,
                    ),
                  )),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            if (!loading) {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  loading ? Colors.grey : Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8,),
                    Expanded(
                      flex: 1,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            if (!loading && allGood) {
                              setState(() {
                                loading = true;
                              });
                              widget.channel.name = _channelNameController.text;
                              widget.channel.link = _channelLinkController.text;
                              widget.channel.logoLink =
                                  _channelLogoLinkController.text;
                              bool? result = await widget.callback(widget.channel);
                              setState(() {
                                loading = false;
                              });
                              if (result != null && result == true) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  !loading && allGood ? Colors.orangeAccent : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  )
                                : Text(
                              widget.edit ? "Update Channel" : "Add Channel",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

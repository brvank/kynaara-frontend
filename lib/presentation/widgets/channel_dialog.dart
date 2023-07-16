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

  @override
  void initState() {
    super.initState();

    _channelNameController.text = widget.channel.name;
    _channelLinkController.text = widget.channel.link;
    _channelLogoLinkController.text = widget.channel.logoLink;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                visible: !loading,
              )
            ],
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.deepOrange,
            controller: _channelNameController,
            decoration: const InputDecoration(
              labelText: "Channel Name",
              border: InputBorder.none,
            ),
            enabled: !loading,
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.deepOrange,
            controller: _channelLinkController,
            decoration: const InputDecoration(
              labelText: "Channel Link",
              border: InputBorder.none,
            ),
            enabled: !loading,
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.deepOrange,
            controller: _channelLogoLinkController,
            decoration: const InputDecoration(
              labelText: "Channel Logo Link",
              border: InputBorder.none,
            ),
            enabled: !loading,
          ),
          TextButton(
            child: loading
                ? CircularProgressIndicator()
                : (widget.edit ? Text("Update Channel") : Text("Add Channel")),
            onPressed: () async {
              if (!loading) {
                setState(() {
                  loading = true;
                });
                widget.channel.name = _channelNameController.text;
                widget.channel.link = _channelLinkController.text;
                widget.channel.logoLink = _channelLogoLinkController.text;
                bool? result = await widget.callback(widget.channel);
                setState(() {
                  loading = false;
                });
                if (result != null && result == true) {
                  Navigator.pop(context);
                }
              }
            },
          )
        ],
      ),
    );
    ;
  }
}

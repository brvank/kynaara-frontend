import 'package:flutter/material.dart';
import 'package:kynaara_frontend/data/model/channel.dart';
import 'package:kynaara_frontend/data/model/product.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/widgets/channel_select_dialog.dart';

class ProductDialog extends StatefulWidget {
  final Function callback;
  final bool edit;
  final Product product;
  const ProductDialog(
      {Key? key,
        required this.callback,
        required this.edit,
        required this.product})
      : super(key: key);

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final TextEditingController _productLinkController = TextEditingController(),
      _productImageLinkController = TextEditingController();

  bool loading = false;

  //to fetch channel, creator and assignee details
  Channel? channel = null;
  User? creator = null, assignee = null;

  @override
  void initState() {
    super.initState();
    _productLinkController.text = widget.product.link;
    _productImageLinkController.text = widget.product.imageLink;
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
            controller: _productLinkController,
            decoration: const InputDecoration(
              labelText: "Product Link",
              border: InputBorder.none,
            ),
            enabled: !loading,
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.deepOrange,
            controller: _productImageLinkController,
            decoration: const InputDecoration(
              labelText: "Product Image Link",
              border: InputBorder.none,
            ),
            enabled: !loading,
          ),
          TextButton(onPressed: () async {
            channel = await showDialog(context: context, builder: (context){
              return ChannelSelectDialog();
            });
          }, child: Text("Select Channel")),
          TextButton(
            child: loading
                ? CircularProgressIndicator()
                : (widget.edit ? Text("Update Product") : Text("Add Product")),
            onPressed: () async {
              if (!loading) {
                if(channel == null){
                  //channel required
                  return;
                }
                setState(() {
                  loading = true;
                });
                widget.product.link = _productLinkController.text;
                widget.product.imageLink = _productImageLinkController.text;
                widget.product.channelId = channel!.id;
                bool? result = await widget.callback(widget.product);
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
  }
}

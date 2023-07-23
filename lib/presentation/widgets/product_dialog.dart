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
  bool allGood = false;

  //to fetch channel, creator and assignee details
  Channel? channel = null;
  User? creator = null, assignee = null;

  @override
  void initState() {
    super.initState();
    _productLinkController.text = widget.product.link;
    _productImageLinkController.text = widget.product.imageLink;

    _productLinkController.addListener(() {
      checkAllGood();
    });

    _productImageLinkController.addListener(() {
      checkAllGood();
    });
  }

  void checkAllGood() {
    if (_productLinkController.text.isNotEmpty &&
        _productImageLinkController.text.isNotEmpty) {
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
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: TextField(
                          autofocus: true,
                          cursorColor: Colors.deepOrange,
                          controller: _productLinkController,
                          decoration: const InputDecoration(
                              labelText: "Product Link",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orangeAccent)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orangeAccent))),
                          enabled: !loading,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: TextField(
                          autofocus: true,
                          cursorColor: Colors.deepOrange,
                          controller: _productImageLinkController,
                          decoration: const InputDecoration(
                              labelText: "Product Image Link",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orangeAccent)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
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
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            if (!loading && allGood) {
                              if (channel == null) {
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
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: !loading && allGood
                                  ? Colors.orangeAccent
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                                : Text(
                              widget.edit ? "Update Product" : "Add Product",
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
  }
}

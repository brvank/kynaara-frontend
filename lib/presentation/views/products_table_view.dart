import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/business_logic/controller/products_table_view_controller.dart';
import 'package:kynaara_frontend/data/model/channel.dart';
import 'package:kynaara_frontend/data/model/product.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/presentation/widgets/channel_select_dialog.dart';
import 'package:kynaara_frontend/presentation/widgets/custom_button.dart';
import 'package:kynaara_frontend/presentation/widgets/custom_select_button.dart';
import 'package:kynaara_frontend/presentation/widgets/product_dialog.dart';
import 'package:kynaara_frontend/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:kynaara_frontend/presentation/widgets/user_select_dialog.dart';
import 'package:kynaara_frontend/utils/constants/ui_text_constants.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';

class ProductsTableView extends StatefulWidget {
  final User user;
  final bool salesPerson;
  const ProductsTableView(
      {Key? key, required this.user, required this.salesPerson})
      : super(key: key);

  @override
  State<ProductsTableView> createState() => _ProductsTableViewState();
}

class _ProductsTableViewState extends State<ProductsTableView> {
  late ProductsTableViewController _productsTableController;

  int start = 0, size = Constants.size, end = 0, total = 0;

  TextEditingController _productLinkController = TextEditingController();
  String _productLink = "";

  Channel? channel;

  @override
  void initState() {
    super.initState();

    _productsTableController = ProductsTableViewController(() {
      logoutUser(context);
    });
  }

  void getProducts() {
    if (channel != null) {
      _productsTableController.getProducts(
          start,
          size,
          _productLink,
          channel!.id,
          (widget.salesPerson ? widget.user.id : null), (start, end, total) {
        this.start = start;
        this.end = end;
        this.total = total;

        setState(() {
          Future.delayed(Duration.zero).then((value) {
            if (_productsTableController.products.isEmpty) {
              getPrev();
            }
          });
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(UITextConstants.channelNotSelected),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoaderBloc>(
            create: (context) {
              return _productsTableController.loaderBloc;
            },
          ),
          BlocProvider<MessageBloc>(
            create: (context) {
              return _productsTableController.messageBloc;
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
                      //extra options
                      Row(
                        children: [
                          CustomSelectButton(
                              selectedText:
                                  channel == null ? "" : channel!.name,
                              labelText: "Selected Channel",
                              text: "Select Channel",
                              callback: () async {
                                channel = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const ChannelSelectDialog();
                                    });

                                if (channel != null) {
                                  getProducts();
                                }
                              }),
                        ],
                      ),
                      //all options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _productLinkController,
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: "Product Link",
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orangeAccent)),
                              ),
                            ),
                          ),
                          CustomButton(
                            text: "Search",
                            callback: () {
                              _productLink = _productLinkController.text;
                              getProducts();
                            },
                          ),
                          CustomButton(
                            text: "Refresh",
                            callback: () {
                              getProducts();
                            },
                          ),
                          CustomButton(
                              text: "Add Product",
                              callback: () {
                                if (channel != null) {
                                  addProductDialog();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        UITextConstants.channelNotSelected),
                                    duration: const Duration(seconds: 2),
                                  ));
                                }
                              }),
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
                                  "Product Url", TabDirection.MID)),
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
                              child: TableTabs.headerTab("", TabDirection.MID)),
                          Expanded(
                              flex: 1,
                              child: TableTabs.headerTab("", TabDirection.MID)),
                          Expanded(
                              flex: 1,
                              child:
                                  TableTabs.headerTab("", TabDirection.RIGHT)),
                        ],
                      ),

                      //all products
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  _productsTableController.products.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.brown,
                                              width: 0.2))),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 1, child: TableTabs.tableTab("${i + 1}")),
                                      Expanded(
                                          flex: 2,
                                          child: TableTabs.tableTab(_productsTableController
                                              .products[i].link)),
                                      Expanded(
                                          flex: 2,
                                          child: TableTabs.tableTab(_productsTableController
                                              .products[i].imageLink)),
                                      Expanded(
                                          flex: 2,
                                          child: TableTabs.tableTab(_productsTableController
                                              .products[i].dateCreated)),
                                      Expanded(
                                          flex: 1,
                                          child: TableTabs.buttonTableTab(
                                            "Copy Link", () {
                                            Clipboard.setData(ClipboardData(text: createProductRedirectLink(_productsTableController.products[i].link)));
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text("Link Copied"),
                                              duration: Duration(seconds: 1),
                                            ));
                                          },
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: TableTabs.buttonTableTab(
                                            "Edit", () {
                                              updateProductDialog(
                                                  _productsTableController
                                                      .products[i]);
                                            },
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: TableTabs.buttonTableTab(
                                            _productsTableController
                                                        .products[i].assigneeId ==
                                                    null
                                                ? "Assign"
                                                : "Re-Assign", () async {
                                              User? user = await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return UserSelectDialog(
                                                      userLevel:
                                                          userLevel(salesPerson),
                                                    );
                                                  });

                                              if (user != null) {
                                                await _productsTableController
                                                    .assignProduct(
                                                        _productsTableController
                                                            .products[i].id,
                                                        user.id);
                                                await Future.delayed(
                                                    Duration.zero);
                                                getProducts();
                                              }
                                            },
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: TableTabs.buttonTableTab(
                                            "Delete", () {
                                              deleteProductDialog(
                                                  _productsTableController
                                                      .products[i].id);
                                            },
                                          )),
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

        getProducts();
      }
    }
  }

  void getNext() {
    if (end <= total && total != 0) {
      if ((start + size) < total) {
        start = start + size;

        getProducts();
      }
    }
  }

  void addProductDialog() {
    Product product = Product(
        id: -1,
        creatorId: -1,
        channelId: channel!.id,
        assigneeId: -1,
        link: "",
        imageLink: "",
        dateCreated: "",
        dateAssigned: "");

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProductDialog(
              callback: (Product product) async {
                bool result =
                    await _productsTableController.addProduct(product);
                await Future.delayed(Duration.zero);
                if (result) {
                  getProducts();
                }
                return result;
              },
              edit: false,
              product: product);
        });
  }

  void updateProductDialog(Product product) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProductDialog(
            callback: (Product product) async {
              bool result =
                  await _productsTableController.updateProduct(product);
              await Future.delayed(Duration.zero);
              if (result) {
                getProducts();
              }

              return result;
            },
            edit: true,
            product: product,
          );
        });
  }

  void deleteProductDialog(int id) async {
    bool? result = await showDialog(
        context: context,
        builder: (context) {
          return DeleteConfirmationDialog();
        });

    if (result != null && result == true) {
      bool result = await _productsTableController.deleteProduct(id);
      await Future.delayed(Duration.zero);
      if (result) {
        getProducts();
      }
    }
  }
}

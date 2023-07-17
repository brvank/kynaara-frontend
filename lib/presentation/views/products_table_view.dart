import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/loading_bloc.dart';
import 'package:kynaara_frontend/business_logic/blocs/message_bloc.dart';
import 'package:kynaara_frontend/business_logic/controller/products_table_view_controller.dart';
import 'package:kynaara_frontend/data/model/product.dart';
import 'package:kynaara_frontend/presentation/widgets/product_dialog.dart';
import 'package:kynaara_frontend/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';

class ProductsTableView extends StatefulWidget {
  const ProductsTableView({Key? key}) : super(key: key);

  @override
  State<ProductsTableView> createState() => _ProductsTableViewState();
}

class _ProductsTableViewState extends State<ProductsTableView> {
  late ProductsTableViewController _productsTableController;

  int start = 0, size = 2, end = 0, total = 0;

  TextEditingController productNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _productsTableController = ProductsTableViewController(() {
      logoutUser(context);
    });

    getProducts();
  }

  void getProducts() {
    _productsTableController.getProducts(
        start, size, productNameController.text, (start, end, total) {
      this.start = start;
      this.end = end;
      this.total = total;

      setState(() {

      });
    });
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
                                addProductDialog();
                              },
                              child: Text("Add Product"))
                        ],
                      ),

                      //all headings
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("S.No.")),
                          Expanded(flex: 2, child: Text("Product Url")),
                          Expanded(flex: 2, child: Text("Link")),
                          Expanded(flex: 2, child: Text("Date of Creation")),
                          Expanded(flex: 1, child: Text("")),
                          Expanded(flex: 1, child: Text("")),
                        ],
                      ),

                      //all products
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                              _productsTableController.products.length,
                              itemBuilder: (context, i) {
                                return Row(
                                  children: [
                                    Expanded(
                                        flex: 1, child: Text("${i+1}")),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_productsTableController
                                            .products[i].link)),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_productsTableController
                                            .products[i].imageLink)),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_productsTableController
                                            .products[i].dateCreated)),
                                    Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          child: Text("Edit"),
                                          onPressed: () {
                                            updateProductDialog(_productsTableController.products[i]);
                                          },
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          child: Text("Delete"),
                                          onPressed: () {
                                            deleteProductDialog(_productsTableController.products[i].id);
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
                              getProducts();
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

        getProducts();
      }
    }
  }

  void getNext(){
    if(end <= total && total != 0){
      if((start + size) < total){
        start = start + size;

        getProducts();
      }
    }
  }

  void addProductDialog() {
    Product product = Product(id: 0, creatorId: 0, channelId: 0, assigneeId: 0, link: "", imageLink: "", dateCreated: "", dateAssigned: "");

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

  void updateProductDialog(Product product){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return ProductDialog(
            callback: (Product product) async {
              bool result = await _productsTableController.updateProduct(product);
              await Future.delayed(Duration.zero);
              if(result){
                getProducts();
              }

              return result;
            },
            edit: true,
            product: product,
          );
        }
    );
  }

  void deleteProductDialog(int id) async {
    bool? result = await showDialog(
        context: context,
        builder: (context){
          return DeleteConfirmationDialog();
        }
    );

    if(result != null && result == true){
      bool result = await _productsTableController.deleteProduct(id);
      await Future.delayed(Duration.zero);
      if(result){
        getProducts();
      }
    }
  }
}
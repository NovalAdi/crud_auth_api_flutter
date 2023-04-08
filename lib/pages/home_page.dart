// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:crud_api_app/models/product.dart';
import 'package:crud_api_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  List<Product> _products = [];

  void getData() {
    ProductService.getProducts().then((value) {
      if (value != null) {
        setState(() {
          _products = value;
        });
      }
    });
  }

  void _showAlertDialog(Product product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: 'Do you want to delete ',
              ),
              TextSpan(
                text: '${product.name}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' ?',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Utils.dialog(
                context,
                () async {
                  await ProductService.deleteProduct(product.id!);
                  final data = await ProductService.getProducts();
                  if (data != null) {
                    setState(() {
                      _products = data;
                    });
                  }
                },
              );
              log('DATA');
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet({Product? product, required bool isUpdate}) {
    if (isUpdate) {
      nameController.text = product!.name!;
      priceController.text = product.price!.toString();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: WidgetsBinding.instance.window.viewInsets.bottom * .5,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isUpdate ? 'Update ${product!.name}' : 'Create Product',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Product Name can not be empty';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      log('Product Name $value');
                    },
                    decoration: InputDecoration(
                      hintText: 'Name',
                      labelText: 'Product Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Product Price can not be empty';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      log('Product price $value');
                    },
                    decoration: InputDecoration(
                      hintText: 'Price',
                      labelText: 'Product Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final name = nameController.text;
                          final price = priceController.text;
                          Navigator.of(context).pop();
                          await Utils.dialog(context, () async {
                            if (isUpdate) {
                              await ProductService.updateProduct(
                                id: product!.id!,
                                name: name,
                                price: price,
                              );
                            } else {
                              await ProductService.createProduct(
                                name: name,
                                price: price,
                              );
                            }
                          });
                          getData();

                          nameController.clear();
                          priceController.clear();
                        } else {
                          log('Not valid');
                        }
                      },
                      icon: Icon(isUpdate ? Icons.update : Icons.save),
                      label: Text(isUpdate ? 'Update' : 'Create'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
    );
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showBottomSheet(isUpdate: false);
          // await Utils.dialog(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder<List<Product>?>(
          future: ProductService.getProducts(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                _products = snapshot.data!;
                if (_products.isEmpty) {
                  return const Center(
                    child: Text('Data still empty'),
                  );
                }

                return ListView.separated(
                    itemBuilder: (_, index) {
                      final product = _products[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id-ID',
                                      name: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(product.price),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // !TOMBOL EDIT
                                  IconButton(
                                    color: Colors.amber,
                                    onPressed: () {
                                      _showBottomSheet(
                                          isUpdate: true, product: product);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  // !TOMBOL DELETE
                                  IconButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      _showAlertDialog(product);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: _products.length);
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

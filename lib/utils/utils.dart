import 'dart:developer';

import 'package:crud_api_app/services/product_service.dart';
import 'package:flutter/material.dart';

class Utils {
  static Future<void> dialog(
      BuildContext context, Future<void> Function() process,
      [bool mounted = true]) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    // await Future.delayed(const Duration(seconds: 3));
    // final datas = await ProductService.getProducts();
    // if (datas != null) {
    //   for (final element in datas) {
    //     log(element.toJson().toString());
    //   }
    // } else {
    //   log('Product NULL');
    // }
    await process();

    // Close the dialog programmatically
    // We use "mounted" variable to get rid of the "Do not use BuildContexts across async gaps" warning
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

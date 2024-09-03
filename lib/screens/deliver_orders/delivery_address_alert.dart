import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/screens/dashboard.dart';

import '../../resource/app_strings.dart';

class DeliveryAddress extends StatefulWidget {
  const DeliveryAddress({Key? key}) : super(key: key);

  @override
  State<DeliveryAddress> createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // centerTitle: true,
        elevation: 6.1,
        title: Text(AppStrings.kDELIVER_ORDERS_PAGE_TITLE),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.location_on_outlined, color: Colors.white),
              onPressed: () {}),
        ],
      ),
    );
  }
}

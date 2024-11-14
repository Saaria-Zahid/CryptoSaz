import 'dart:convert';
import 'package:coin_market/coin_details.dart';
import 'package:coin_market/coin_list.dart';
import 'package:coin_market/services/db_helper.dart';
import 'package:flutter/material.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  List<Map<String, dynamic>> data = [];
  dataCall() async {
    List<Map<String, dynamic>> datalist =
        await DBhelper.instance.queryDatabase();
    setState(() {
      data = datalist;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                height: 200,
                child: Text(
                  "My Assets",
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index]["CoinId"]),
                      subtitle: Text(data[index]["CoinQty"]),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

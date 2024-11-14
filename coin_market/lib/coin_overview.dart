import 'dart:convert';
import 'package:coin_market/coin_details.dart';
import 'package:coin_market/coin_list.dart';
import 'package:coin_market/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class CoinOverview extends StatefulWidget {
  var coinId;

  CoinOverview(this.coinId, {super.key});

  @override
  State<CoinOverview> createState() => _CoinOverviewState();
}

class _CoinOverviewState extends State<CoinOverview> {
  var timeVal = 30;

// onTimeChange(var value){
//   if (value != null) {

// timeVal = value;
//   } else {
// timeVal = 1;

//   }
// }

  late Map<String, dynamic> resMap = {};
  late List resList = [];
  late Map chartRes;
  late List chartList = [];
  bool isLoading = false;
  // late List HomeLinks = [];

  Future apiCall() async {
    if (isLoading)
      return setState(() {
        isLoading = true;
      });

    var cid = widget.coinId;
    try {
      http.Response listResponse = await http.get(Uri.parse(
          "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"));
      http.Response response = await http
          .get(Uri.parse("https://api.coingecko.com/api/v3/coins/$cid"));
      http.Response responseChart = await http.get(Uri.parse(
          "https://api.coingecko.com/api/v3/coins/$cid/market_chart?vs_currency=usd&days=$timeVal"));

      if (response.statusCode == 200) {
        setState(() {
          resList = jsonDecode(listResponse.body);

          resMap = jsonDecode(response.body);
          chartRes = jsonDecode(responseChart.body);
          chartList = chartRes['prices'];
          // HomeLinks = resMap['links']['homepage'];
        });
      }
    } catch (error) {
      print("Error:  $error");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCall();
  }



  TextEditingController CoinQtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: resMap.isNotEmpty && chartList.isNotEmpty
            ? Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "${resMap['name']}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${resMap['market_data']['current_price']['usd'].toString()}",
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                    resMap['market_data'][
                                                'price_change_percentage_24h'] >
                                            0
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: resMap['market_data'][
                                                'price_change_percentage_24h'] >
                                            0
                                        ? Colors.green
                                        : Colors.red),
                                Text(
                                    '${resMap['market_data']['price_change_percentage_24h'].toStringAsFixed(2)}%')
                              ],
                            )
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ChartTab(chartData: chartList),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TimeBtn("24H", 1),
                      TimeBtn("7D", 7),
                      TimeBtn("15D", 15),
                      TimeBtn("30D", 30),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                BottomSellingSheet(0);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(10.0),
                                backgroundColor: Colors.green[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: const Text(
                                'BUY',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                BottomSellingSheet(1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[800],
                                padding: EdgeInsets.all(10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: const Text('Sell',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          MarkData(
                              Data: resMap,
                              text: "Market Cap",
                              DType: "market_cap",
                              DType2: "usd"),
                          MarkData(
                              Data: resMap,
                              text: "High 24h",
                              DType: "high_24h",
                              DType2: "usd"),
                          MarkData(
                              Data: resMap,
                              text: "Low 24h",
                              DType: "low_24h",
                              DType2: "usd"),
                          MarkData(
                            Data: resMap,
                            text: "Circulating Supply",
                            DType: "circulating_supply",
                          ),
                          MarkData(
                            Data: resMap,
                            text: "FDV Ratio",
                            DType: "market_cap_fdv_ratio",
                          ),
                          MarkData(
                              Data: resMap,
                              text: "FDV Value",
                              DType: "fully_diluted_valuation",
                              DType2: "usd"),
                          MarkData(
                              Data: resMap,
                              text: "Trading Volume",
                              DType: "total_volume",
                              DType2: "usd"),
                          MarkData(
                              Data: resMap,
                              text: "Total Supply",
                              DType: "total_supply"),
                          MarkData(
                              Data: resMap,
                              text: "Max Supply",
                              DType: "max_supply"),
                        ],
                      ),
                    ),
                  ),SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Coins You May Like",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 150,
                        minWidth: double.infinity,
                        maxWidth: double.infinity,
                        maxHeight: 165),
                    child: GridCoinsList(resList),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget TimeBtn(String text, int val) {
    return ElevatedButton(
      onPressed: isLoading
          ? null // Disable button while loading
          : () {
              setState(() {
                timeVal = val;
              });
              apiCall();
            },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        backgroundColor: const Color.fromARGB(92, 144, 202, 249),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }

  Future BottomSellingSheet(id) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          var myColors = id == 0 ? Colors.greenAccent : Colors.redAccent;
          var myBtnColors = id == 0 ? Color(0xFF00C853) : Colors.red[900];
          var myText = id == 0 ? "Buy" : "Sell";

          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E), // Background color for the sheet
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(resMap['image']['thumb']),
                    SizedBox(width: 8),
                    Text(
                      '${resMap['symbol'].toUpperCase()}', // Replace with dynamic coin name if needed
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quantity',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: CoinQtyController,
                  style: TextStyle(color: Colors.white), // Text color
                  cursorColor: myColors, // Cursor color
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(
                        0xFF22273A), // Darker background for the text field
                    hintText: 'Enter amount to ${myText}',
                    hintStyle:
                        TextStyle(color: Colors.white54), // Hint text color
                    prefixIcon: Icon(Icons.monetization_on, color: myColors),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: myColors),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    var coinId = resMap['id'];

                    if (id == 0) {
                      var coinQty = CoinQtyController.text;
                      DBhelper.instance.insertRecord({
                        DBhelper.ColumnCoinId: coinId,
                        DBhelper.ColumnQty: coinQty,
                      });
                    } else {
                      var coinQty = CoinQtyController.text;
                      DBhelper.instance.updateRecord({
                        DBhelper.ColumnQty: coinQty,
                        DBhelper.ColumnId: id,
                      });
                    }
                    CoinQtyController.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myBtnColors, // Button color
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '${myText} Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        });
    ;
  }
}

import 'dart:convert';
import 'package:coin_market/coin_details.dart';
import 'package:coin_market/wallet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List resList = [];
  late Map chartRes;
  late List chartList = [];

  Future<void> apiCall() async {
    List<String> ids = [
      "bitcoin",
      "ethereum",
      "litecoin",
      "bitcoin-cash",
      "dogecoin",
      "monero",
    ];
    var cid = ids[0];
    final response = await http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"));
    final responseChart = await http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/$cid/market_chart?vs_currency=usd&days=1"));

    if (response.statusCode == 200 && responseChart.statusCode == 200) {
      setState(() {
        resList = jsonDecode(response.body);
        chartRes = jsonDecode(responseChart.body);
        chartList = chartRes['prices'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        leading: const Icon(
          Icons.logo_dev,
          size: 40,
        ),
        title: Text("CryptoSaz"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyWallet()));
            },
            icon: const Icon(Icons.wallet),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        "assets/images/banner.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
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
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Coins Market",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: LoadCheck(
                condition: resList.isNotEmpty,
                trueQuery: Column(
                  children: resList.map((item) {
                    String formatNumber(double number) {
                      if (number >= 1e9) {
                        return '${(number / 1e9).toStringAsFixed(2)}B';
                      } else if (number >= 1e6) {
                        return '${(number / 1e6).toStringAsFixed(2)}M';
                      } else {
                        return number.toStringAsFixed(2);
                      }
                    }

                    var coinId = item['id'];

                    return Card(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CoinScr(coinId)));
                          },
                          leading: Image.network(
                            item['image'],
                            width: 50,
                            height: 50,
                          ),
                          title: Text(item['name']),
                          subtitle: Row(
                            children: [
                              Text(
                                " ${resList.indexOf(item) + 1}. ",
                                style: const TextStyle(),
                              ),
                              Icon(
                                  item['price_change_percentage_24h'] > 0
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: item['price_change_percentage_24h'] > 0
                                      ? Colors.green
                                      : Colors.red),
                              Text(
                                  '${item['price_change_percentage_24h'].toStringAsFixed(2)}%')
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Text(
                                "\$${item['current_price'].toStringAsFixed(2)}",
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  " MCap ${formatNumber(item['market_cap'].toDouble())}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget LoadCheck({required bool condition, required Widget trueQuery}) {
  return condition
      ? trueQuery
      : const Center(
          child: CircularProgressIndicator(),
        );
}

Widget GridCoinsList(List map) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: map.length >= 10 ? 10 : map.length,
    itemBuilder: (context, index) {
      var coinId = map[index]['id'];
      var coinName = map[index]['symbol'];
      var coinImage = map[index]['image'];
      var coinPrice = map[index]['current_price'].toStringAsFixed(2);
      var coinTH = map[index]['price_change_percentage_24h'].toStringAsFixed(2);
      return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CoinScr(coinId)));
        },
        child: Card(
          color: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Container(
            constraints: BoxConstraints(
                minWidth: 150, maxWidth: 165, maxHeight: 165, minHeight: 150),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nested Row for the image and coin name
                    Row(
                      children: [
                        Image.network(
                          coinImage,
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                            width:
                                5), // Add spacing between the image and the text
                        Text(
                          coinName.toUpperCase(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),

                    // Icon button on the far right
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.star_border),
                      iconSize: 18, // Adjust icon size if needed
                    ),
                  ],
                ),
                Text("\$$coinPrice", style: TextStyle(fontSize: 24)),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                          map[index]['price_change_percentage_24h'] > 0
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: map[index]['price_change_percentage_24h'] > 0
                              ? Colors.green
                              : Colors.red),
                      Text(
                          '${map[index]['price_change_percentage_24h'].toStringAsFixed(2)}%')
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

import 'dart:convert';
import 'package:coin_market/coin_overview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class CoinScr extends StatefulWidget {
  var coinId;
  CoinScr(this.coinId, {super.key});

  @override
  State<CoinScr> createState() => _CoinScrState();
}

class _CoinScrState extends State<CoinScr> {
  late Map<String, dynamic> resMap = {};
  late Map chartRes;
  late List chartList = [];
  // late List HomeLinks = [];

  Future apiCall() async {
    var cid = widget.coinId;
    http.Response response = await http
        .get(Uri.parse("https://api.coingecko.com/api/v3/coins/$cid"));
    http.Response responseChart = await http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/$cid/market_chart?vs_currency=usd&days=1"));

    if (response.statusCode == 200) {
      setState(() {
        resMap = jsonDecode(response.body);
        chartRes = jsonDecode(responseChart.body);
        chartList = chartRes['prices'];
        // HomeLinks = resMap['links']['homepage'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: resMap.isNotEmpty
            ? Scaffold(
                appBar: AppBar(
                  title: Row(
                    // mainAxisAlignment: main,
                    children: [
                      Image.network(resMap['image']['thumb']),
                      Text(
                        resMap['name'],
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  bottom: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(text: 'About'),
                      // Tab(text: 'Tickers'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    CoinOverview(widget.coinId),
                    LinksTab(context: context, respon: resMap),
                  ],
                ),
              )
            : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
  }
}

// Widgets

Widget ChartTab({required var chartData}) {
  // TODO: Implement Exchanges Tab
  return LineChart(
    LineChartData(
      gridData: FlGridData(
        show: false,
        // drawVerticalLine: true,
        drawHorizontalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.5),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.5),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: chartData.map<FlSpot>((point) {
            double timestamp = point[0].toDouble();
            double price = point[1].toDouble();
            double scaledTimestamp =
                timestamp / 1000000000; // Scale down to avoid large x values
            return FlSpot(scaledTimestamp, price);
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: chartData.last[1] > chartData.first[1]
                ? [
                    Colors.green,
                    Colors.greenAccent
                  ] // Green gradient if increased
                : [Colors.redAccent, Colors.pink], // Red gradient if decreased
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment
                  .bottomCenter, // Defines the direction of the gradient
              stops: const [
                0.2,
                1.0
              ], // Position of the colors in the gradient (from top to bottom)
              colors: chartData.last[1] > chartData.first[1]
                  ? [
                      Colors.green.shade900,
                      const Color(0xFF121212)
                    ] // Green gradient if increased
                  : [
                      Colors.red.shade900,
                      const Color(0xFF121212)
                    ], // Red gradient if decreased
            ),
          ),
        ),
      ],
    ),
  );
}

Widget TickersTab() {
  // TODO: Implement Tickers Tab
  return Container(
    child: const Text("Tickers Tab"),
  );
}

Widget MarkData({
  required var Data,
  required var text,
  required var DType,
  var DType2,
}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Card(
          color: Color(0xFF1A1A2E),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // mtypes key and value

                Text(
                  text,
                ),
                DType2 != null
                    ? Text(
                        "${Data["market_data"][DType][DType2]}",
                      )
                    : Text(
                        "${Data["market_data"][DType]}",
                      )
              ],
            ),
          ),
        ),
      ));
}

Widget LinksTab({
  required BuildContext context,
  required var respon,
}) {
  // Extract the links object
  // Extract the links object
  var links = respon["links"];

// Define dataList with a conditional operator based on respon.isNotEmpty
  List<Map<String, dynamic>> dataList = respon.isNotEmpty
      ? [
          {"title": "Homepage", "data": links["homepage"]},
          {
            "title": "Whitepaper",
            "data": [links["whitepaper"]]
          }, // Single value wrapped in list
          {"title": "Blockchain Sites", "data": links["blockchain_site"]},
          {"title": "Official Forum", "data": links["official_forum_url"]},
          {"title": "Chat URLs", "data": links["chat_url"]},
          {"title": "Announcement URLs", "data": links["announcement_url"]},
          {
            "title": "Twitter username",
            "data": [links["twitter_screen_name"]]
          },
          {
            "title": "Facebook username",
            "data": [links["facebook_username"]]
          },
          {
            "title": "Subreddit",
            "data": [links["subreddit_url"]]
          },
          {
            "title": "GitHub Repositories",
            "data": links["repos_url"]["github"]
          },
          {
            "title": "Bitbucket Repositories",
            "data": links["repos_url"]["bitbucket"]
          },
        ]
      : []; // Empty list if respon is empty

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          // Get the current section
          var section = dataList[index];
          var title = section["title"];
          var data = section["data"];

          // Filter out empty strings from the data
          List<String> validData =
              List<String>.from(data).where((item) => item.isNotEmpty).toList();

          return Card(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  // List of URLs or names for the section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: validData.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          item,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

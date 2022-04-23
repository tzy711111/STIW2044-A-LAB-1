import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

class BitCoinExPage extends StatefulWidget {
  const BitCoinExPage({Key? key}) : super(key: key);

  @override
  State<BitCoinExPage> createState() => _BitCoinExState();
}

class _BitCoinExState extends State<BitCoinExPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BitCoin Cryptocurrency Exchange',
                style: TextStyle(fontSize: 15, color: Colors.white)),
        elevation: 2.0,
        centerTitle: true,
      ),
      
      body: const HomePage(),
      backgroundColor: Colors.grey[200],
      );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController valueEditingController = TextEditingController();

  var name, unit, value, type;
  String desc="No Available Information";
  String unitCur = "BTC";
  double valueCur = 1.0;
  double exvalue = 1.0;
  double result = 1.0;

  String selectCur = "btc";
  List<String> curList = [
    "btc", "eth", "ltc", "bch", "bnb", "eos", "xrp", "xlm", "link", "dot", "yfi", 
    "usd", "aed", "ars", "aud", "bdt", "bhd", "bmd", "brl", "cad", "chf", "clp", "cny", "czk", "dkk", "eur", "gbp", "hkd", "huf", "idr", 
    "ils", "inr", "jpy", "krw", "kwd", "lkr", "mmk", "mxn", "myr", "ngn", "nok", "nzd", "php", "pkr", "pln", "rub", "sar", "sek", "sgd", "thb", 
    "try", "twd", "uah", "vef", "vnd", "zar", "xdr", "xag", "xau", "bits", "sats"
  ];

    @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 110.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0.0,3.0))
              ]),
             child: Padding(
               padding: const EdgeInsets.all(5.0),
               child: Row(
                    children: [
                      Expanded(
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                         Image.asset('assets/images/bitcoin-icon.png',height:65.0, width: 65.0),
                         const Text("1 BitCoin"),
                         ]
                       ),
                      ),  
                      Expanded(
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                         Image.asset('assets/images/exchange.png',height: 50.0, width: 50.0),
                         ]
                       ),
                      ),
                      Expanded(
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                         Image.asset('assets/images/currency-icon.png',height: 65.0, width: 55.0),
                         Text(unitCur + valueCur.toString()),
                         ]
                       ),
                      ),
                    ],)
              )
            ),

          const SizedBox(height:13.0),
          
          Container(
            height: 170.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0.0,3.0))
              ]),

             child: Padding(
               padding: const EdgeInsets.all(7.0),
               child: Column(
                children: [
                    Row(
                        children: [
                        const SizedBox(width:20.0),
                         const Text("Select Currency"),
                         const SizedBox(width:75.0),
                         DropdownButton(
                         itemHeight: 60,
                          value: selectCur,
                          onChanged: (newValue) {
                          setState(() {
                         selectCur = newValue.toString();
                         });
                         },

                        items: curList.map((selectCur) {
                        return DropdownMenuItem(
                          child: Text(
                          selectCur,
                       ),
                      value: selectCur,
                      );      
                     }).toList(),
                    ),
                    ],
                     ),
                     
                     SizedBox(
                       width: 230,
                       height: 35,
                       child: TextField(
  
                         controller: valueEditingController,
                          keyboardType: const TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                          hintText: "Input BitCoin",
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                             ),
                        ),
                     ),       
                      const SizedBox(height:8.0),
                      SizedBox(
                       width: 170,
                       height: 40,
                       child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                             shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              ),
                              ),
                          onPressed: _loadExchange, child: const Text("Exchange")),
                       ),
                      ], 
              ),
          ), 
          ),
                    const SizedBox(height:13.0),

          Container(
            height: 130.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0.0,3.0))
              ]),

              child: Column(
                children: [
                  const SizedBox(height:10.0),
                  const Text("Exchange Result\n", 
                  style:  TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  Text(desc),
                ],
              ),

          ),
        ],
      ),
      ),
    );
  }

  _loadExchange() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Exchanging..."));
    progressDialog.show();
    exvalue = double.parse(valueEditingController.text);
    var url = Uri.parse(
        'https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
     
        name = parsedJson['rates'][selectCur]['name'];
        unit = parsedJson['rates'][selectCur]['unit'];
        value = parsedJson['rates'][selectCur]['value'];
        type= parsedJson['rates'][selectCur]['type'];
        unitCur = "$unit";
        valueCur = value;
        result = valueCur * exvalue;

     setState(() {  
        desc="Name = $name\n" "Unit = $unit\n"  "Value = $result\n"   "Type = $type";
      });
  }
    progressDialog.dismiss();
  }
}
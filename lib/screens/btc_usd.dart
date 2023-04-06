import 'package:bitcoin_calculator/utils/convert.dart';
import 'package:flutter/material.dart';

class BtcUsd extends StatefulWidget {

  final double price;
  final bool error;
  BtcUsd(this.price, this.error);  

  @override
  _BtcUsdState createState() => _BtcUsdState();
}

class _BtcUsdState extends State<BtcUsd> {

  final usdEntered = TextEditingController();
  bool valid = false;
  bool convert = false;
  double usd = 0;
  double roundedUsd = 0;
  int usingBtc = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
            key: Key('back2'),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),    

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              child: widget.error? Align(alignment: Alignment.center,
                child: Text("ERROR RETRIEVING DATA",
                key: Key('error2'),
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              ): Text(''),
            ),       

            SizedBox(height: 20),

            Container(
              child: convert && valid? Align(alignment: Alignment.center,
                child: Text("$roundedUsd USD",
                key: Key('USD'),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
              ): Text(''),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)
              ),
                child: TextField(
                key: Key('btcInput'),
                controller: usdEntered,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: (value) {
                  convert = false;
                  setState(() {
                    if(widget.price != null){
                      if(valid = PriceConverter.validBtcInput(value)){
                        usd = PriceConverter.btcUsdConverter(double.parse(value), widget.price);
                        roundedUsd = double.parse(usd.toStringAsFixed(2));
                      }
                    }
                  });
                }
              ),
            ),

            SizedBox(height: 4),

            Container(
              margin: EdgeInsets.only(left: 50),
              child: valid || usdEntered.text.isEmpty? Text(''): Align(alignment: Alignment.centerLeft,
                child: Text('Invalid input',
                  key: Key('invalid2'),
                  style: TextStyle(
                  color: Colors.red,
                  )
                ),
              )
            ),

            ElevatedButton(
              onPressed: () {
                convert = true;
                setState(() {
                });
              },
              child: Text(
                "Convert",
                key: Key('convert2'),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(160, 50),
                primary: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              )
            )
          ],
        ),
      ),
    );
  }
}

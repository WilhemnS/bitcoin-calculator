import 'package:http/http.dart' as http;
import 'dart:convert';

class BitcoinApi {
  static Future<double> fetchPrice(http.Client client) async {
    var url = Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json');
    final response = await client.get(url);
    double rateFloat;
    
    if(response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      rateFloat = json['bpi']['USD']['rate_float'];
      return rateFloat;
    }else{
      throw Exception('Error retrieving data');
    }
  }
}
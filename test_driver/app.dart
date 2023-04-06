import 'package:flutter_driver/driver_extension.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:bitcoin_calculator/config/globals.dart' as globals;
import 'package:bitcoin_calculator/main.dart' as app;

class MockClient extends Mock implements http.Client {}

void main() {

      enableFlutterDriverExtension();

      final mockitoClient = MockClient();
      final mockHTTP = '{"time":{"updated":"Mar 30, 2023 21:27:00 UTC","updatedISO":"2023-03-30T21:27:00+00:00","updateduk":"Mar 30, 2023 at 22:27 BST"},"disclaimer":"This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org","bpi":{"USD":{"code":"USD","rate":"28,109.4393","description":"United States Dollar","rate_float":28109.4393}}}';
      
      when(mockitoClient.get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json'))).thenAnswer((_) async => http.Response(mockHTTP, 200));

      globals.httpClient = mockitoClient;

      app.main();

}
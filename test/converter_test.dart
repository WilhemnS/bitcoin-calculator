import 'package:bitcoin_calculator/config/globals.dart';
import 'package:bitcoin_calculator/utils/convert.dart';
import 'package:bitcoin_calculator/utils/retrieve.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {

  final mockitoClient = MockClient();
  final mockHTTP = '{"time":{"updated":"Mar 30, 2023 20:47:00 UTC","updatedISO":"2023-03-30T20:47:00+00:00","updateduk":"Mar 30, 2023 at 21:47 BST"},"disclaimer":"This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org","bpi":{"USD":{"code":"USD","rate":"28,146.5076","description":"United States Dollar","rate_float":28146.5076}}}';

  group("http responses", () {
    
    test("http response successful", () async {
      when(mockitoClient.get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json')))
          .thenAnswer((_) async => http.Response(mockHTTP, 200));
      final res = await BitcoinApi.fetchPrice(mockitoClient);
      expect(res, isA<double>());
      expect(res, 28146.5076);
    });

    test("http response unsuccessful", () async {
      when(mockitoClient.get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice/usd.json')))
          .thenAnswer((_) async => http.Response(mockHTTP, 404));
      expect(() async => await BitcoinApi.fetchPrice(mockitoClient),
          throwsException);
    }); 
    
  });

  group("usdToBtc", () {
    
    test("Should get correct value when USD is 1", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var btc = PriceConverter.usdBtcConverter(1, res);
      expect(btc, 1 / res);
    });

    test("Should get correct value when USD is 4", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var btc = PriceConverter.usdBtcConverter(4, res);
      expect(btc, 4 / res);
    });

    test("Should get correct value when USD is 0", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var btc = PriceConverter.usdBtcConverter(0, res);
      expect(btc, 0 / res);
    });

    test("Should get correct value when USD is 0.1", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var btc = PriceConverter.usdBtcConverter(0.1, res);
      expect(btc, 0.1 / res);
    });    

    test("Should get correct value when USD is 0.12", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var btc = PriceConverter.usdBtcConverter(0.12, res);
      expect(btc, 0.12 / res);
    });

    test("Should get argument error when USD is -1", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      expect(
          () => PriceConverter.usdBtcConverter(-1, res), throwsArgumentError);
    });
    
  });

  group('btcToUsd', () {

    test("Should get correct value when btc is 1", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var usd = PriceConverter.btcUsdConverter(1, res);
      expect(usd, 1 * res);
    });

    test("Should get correct value when btc is 4", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var usd = PriceConverter.btcUsdConverter(4, res);
      expect(usd, 4 * res);
    });

    test("Should get correct value when btc is 1.5", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var usd = PriceConverter.btcUsdConverter(1.5, res);
      expect(usd, 1.5 * res);
    });
    
        test("Should get correct value when btc is 1.05", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var usd = PriceConverter.btcUsdConverter(1.05, res);
      expect(usd, 1.05 * res);
    });

    test("Should get 0 usd when btc is 0", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      var usd = PriceConverter.usdBtcConverter(0, res);

      expect(usd, 0);
    });

    test("Should get argument error when btc is -1", () async {
      final res = await BitcoinApi.fetchPrice(httpClient);
      expect(
          () => PriceConverter.usdBtcConverter(-1, res), throwsArgumentError);
    });
    
  });

  group('validInput usd', () {
    
    test('1 usd input should be true', () {
      bool input = PriceConverter.validUsdInput("1");
      expect(input, isTrue);
    });

    test('-1 usd input should be false', () {
      bool input = PriceConverter.validUsdInput("-1");
      expect(input, isFalse);
    });
    
    test('h usd input should be false', () {
      bool input = PriceConverter.validUsdInput("h");
      expect(input, isFalse);
    });

    test('0.1 usd (1 decimal) input should be true', () {
      bool input = PriceConverter.validUsdInput("0.1");
      expect(input, isTrue);
    });

    test('0.13 usd (2 decimals) input should be true', () {
      bool input = PriceConverter.validUsdInput("0.12");
      expect(input, isTrue);
    });

    test('0.111 usd (3 decimals, only should be up to 2) input should be false', () {
      bool input = PriceConverter.validUsdInput("0.123");
      expect(input, isFalse);
    });

  });

  group('validInput btc', () {

    test('1 btc input should be true', () {
      bool input = PriceConverter.validBtcInput("1");
      expect(input, isTrue);
    });

    test('-1 btc input should be false', () {
      bool input = PriceConverter.validBtcInput("-1");
      expect(input, isFalse);
    });
    
    test('h btc input should be false', () {
      bool input = PriceConverter.validBtcInput("h");
      expect(input, isFalse);
    });

    test('0.1 btc (1 decimal) input should be true', () {
      bool input = PriceConverter.validBtcInput("0.1");
      expect(input, isTrue);
    });

    test('0.12345678 btc (up to 8 decimals) input should be true', () {
      bool input = PriceConverter.validBtcInput("0.12345678");
      expect(input, isTrue);
    });

    test('0.123456789 btc (9 decimals, only should be up to 8) input should be false', () {
      bool input = PriceConverter.validBtcInput("0.123456789");
      expect(input, isFalse);
    });

  });

}

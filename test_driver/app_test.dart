// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {

  FlutterDriver driver;

  // Connect to the Flutter driver before running any tests.
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  // Close the connection to the driver after the tests have completed.
  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  group('Happy Paths', () {

    test('should convert usd to btc, with a whole number', () async {

      final usdBtc = find.byValueKey('usd-btc');
      final input = find.byValueKey('usdInput');
      final convert = find.byValueKey('convert1');
      final btc = find.byValueKey('BTC');

      expect(await driver.getText(usdBtc), "USD to BTC");

      await driver.tap(usdBtc);

      expect(await driver.getText(convert), "Convert");

      await driver.tap(input);
      await driver.enterText('5');
      expect(await driver.getText(input), "5");   

      await driver.tap(convert);

      expect(await driver.getText(btc), "0.00017787619121950967 BTC");   

    });

    test("1 decimal place", () async {

      final input = find.byValueKey('usdInput');
      final convert = find.byValueKey('convert1');
      final btc = find.byValueKey('BTC');

      await driver.tap(input);
      await driver.enterText('5.1');
      expect(await driver.getText(input), "5.1");   

      await driver.tap(convert);

      expect(await driver.getText(btc), "0.00018143371504389987 BTC");  

    });

    test("2 decimal places", () async {

      final input = find.byValueKey('usdInput');
      final convert = find.byValueKey('convert1');
      final btc = find.byValueKey('BTC');
      final usdBtc = find.byValueKey('usd-btc');
      final back1 = find.byValueKey('back1');

      await driver.tap(input);
      await driver.enterText('5.12');
      expect(await driver.getText(input), "5.12");   

      await driver.tap(convert);

      expect(await driver.getText(btc), "0.0001821452198087779 BTC");  

      await driver.tap(back1);

      expect(await driver.getText(usdBtc), "USD to BTC");
      
    });

    test('should convert btc to usd, with a whole number', () async {

      final btcUsd = find.byValueKey('btc-usd');
      final input = find.byValueKey('btcInput');
      final convert = find.byValueKey('convert2');
      final usd = find.byValueKey('USD');

      expect(await driver.getText(btcUsd), "BTC to USD");

      await driver.tap(btcUsd);

      expect(await driver.getText(convert), "Convert");

      await driver.tap(input);
      await driver.enterText('5');
      expect(await driver.getText(input), "5");   

      await driver.tap(convert);

      expect(await driver.getText(usd), "140547.2 USD");   

    });    

    test('1 decimal place', () async {

      final input = find.byValueKey('btcInput');
      final convert = find.byValueKey('convert2');
      final usd = find.byValueKey('USD');

      await driver.tap(input);
      await driver.enterText('5.1');
      expect(await driver.getText(input), "5.1");   

      await driver.tap(convert);

      expect(await driver.getText(usd), "143358.14 USD");   

    }); 

    test('2 decimal places', () async {

      final btcUsd = find.byValueKey('btc-usd');
      final input = find.byValueKey('btcInput');
      final convert = find.byValueKey('convert2');
      final usd = find.byValueKey('USD');

      await driver.tap(input);
      await driver.enterText('5.12');
      expect(await driver.getText(input), "5.12");   

      await driver.tap(convert);

      expect(await driver.getText(usd), "143920.33 USD");   


    }); 

    test('8 decimal places', () async {

      final btcUsd = find.byValueKey('btc-usd');
      final input = find.byValueKey('btcInput');
      final convert = find.byValueKey('convert2');
      final usd = find.byValueKey('USD');
      final back2 = find.byValueKey('back2');

      await driver.tap(input);
      await driver.enterText('5.12345678');
      expect(await driver.getText(input), "5.12345678");   

      await driver.tap(convert);

      expect(await driver.getText(usd), "144017.5 USD");   

      await driver.tap(back2);

      expect(await driver.getText(btcUsd), "BTC to USD");

    }); 

  });

  group('Sad Paths', () {

    test('input 3 decimal places on usd to btc should give error', () async {
      final input = find.byValueKey('usdInput');
      final convert = find.byValueKey('convert1');
      final invalid1 = find.byValueKey('invalid1');
      final usdBtc = find.byValueKey('usd-btc');
          
      await driver.tap(usdBtc);
      expect(await driver.getText(input), "");   
      await driver.tap(input);
      await driver.enterText('0.111');
      expect(await driver.getText(input), "0.111");   
      await driver.tap(convert);
      expect(await driver.getText(invalid1), "Invalid input");              
    });

    test('input h on usd to btc should give error', () async {
      final input = find.byValueKey('usdInput');
      final convert = find.byValueKey('convert1');
      final invalid1 = find.byValueKey('invalid1');

      expect(await driver.getText(convert), "Convert");     
      await driver.tap(input);
      await driver.enterText('h');
      expect(await driver.getText(input), "h");   
      await driver.tap(convert);
      expect(await driver.getText(invalid1), "Invalid input");              
    });

    test('input -1 on usd to btc should give error', () async {
      final usdBtc = find.byValueKey('usd-btc');
      final input = find.byValueKey('usdInput');
      final convert = find.byValueKey('convert1');
      final invalid1 = find.byValueKey('invalid1');
      final back1 = find.byValueKey('back1');

      expect(await driver.getText(convert), "Convert");     
      await driver.tap(input);
      await driver.enterText('-1');
      expect(await driver.getText(input), "-1");   
      await driver.tap(convert);
      expect(await driver.getText(invalid1), "Invalid input");      

      await driver.tap(back1);
      expect(await driver.getText(usdBtc), "USD to BTC");  
    });


    test('input 9 decimal places on btc to usd should give error', () async {

      final input = find.byValueKey('btcInput');
      final convert = find.byValueKey('convert2');
      final invalid2 = find.byValueKey('invalid2');
      final btcUsd = find.byValueKey('btc-usd');

      await driver.tap(btcUsd);
      expect(await driver.getText(input), "");   
      await driver.tap(input);
      await driver.enterText('0.123456789');
      expect(await driver.getText(input), "0.123456789");   
      await driver.tap(convert);
      expect(await driver.getText(invalid2), "Invalid input");

    });

    test('input h on btc to usd should give error', () async {

      final input = find.byValueKey('btcInput');
      final convert = find.byValueKey('convert2');
      final invalid2 = find.byValueKey('invalid2');

      expect(await driver.getText(convert), "Convert");

      await driver.tap(input);
      await driver.enterText('h');
      expect(await driver.getText(input), "h");   
      await driver.tap(convert);
      expect(await driver.getText(invalid2), "Invalid input");

    });

    test('input -1 on btc to usd should give error', () async {

      final btcUsd = find.byValueKey('btc-usd');
      final input = find.byValueKey('btcInput');
      final convert = find.byValueKey('convert2');
      final invalid2 = find.byValueKey('invalid2');
      final back2 = find.byValueKey('back2');

      expect(await driver.getText(convert), "Convert");

      await driver.tap(input);
      await driver.enterText('-1');
      expect(await driver.getText(input), "-1");   
      await driver.tap(convert);
      expect(await driver.getText(invalid2), "Invalid input");      

      await driver.tap(back2);

      expect(await driver.getText(btcUsd), "BTC to USD"); 

    });             
  });

  group('back buttons', (){
    test('back button from usd to btc', () async{
      final usdBtc = find.byValueKey('usd-btc');
      final input = find.byValueKey('usdInput');
      final convert = find.byValueKey('convert1');
      final btc = find.byValueKey('BTC');
      final back1 = find.byValueKey('back1');

      expect(await driver.getText(usdBtc), "USD to BTC");

      await driver.tap(usdBtc);

      expect(await driver.getText(convert), "Convert");

      await driver.tap(input);
      await driver.enterText('5');
      expect(await driver.getText(input), "5");   

      await driver.tap(convert);

      expect(await driver.getText(btc), "0.00017787619121950967 BTC");  

      await driver.tap(back1);

      expect(await driver.getText(usdBtc), "USD to BTC");
    });

    test('back button from btc to usd', () async{
      final btcUsd = find.byValueKey('btc-usd');
      final input = find.byValueKey('btcInput');
      final convert = find.byValueKey('convert2');
      final usd = find.byValueKey('USD');
      final back2 = find.byValueKey('back2');

      expect(await driver.getText(btcUsd), "BTC to USD");

      await driver.tap(btcUsd);

      expect(await driver.getText(convert), "Convert");

      await driver.tap(input);
      await driver.enterText('5');
      expect(await driver.getText(input), "5");   

      await driver.tap(convert);

      expect(await driver.getText(usd), "140547.2 USD");   

      await driver.tap(back2);

      expect(await driver.getText(btcUsd), "BTC to USD");
    });
  });  

}



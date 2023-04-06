class PriceConverter{

  static double usdBtcConverter(double usd, double currPrice){
    if(usd < 0){
      throw ArgumentError();
    }
    double btc = currPrice;
    double res = usd / btc;
    return res;
  }

  static double btcUsdConverter(double btc, double currPrice){
    if(btc < 0){
      throw ArgumentError();
    }
    double usd = currPrice;
    double res = usd * btc;
    return res;
  }

  static bool validUsdInput(String userInput){
      return RegExp(r'^[0-9]\d*(\.\d{1,2})?$').hasMatch(userInput);
  }

  static bool validBtcInput(String userInput){
      return RegExp(r'^[0-9]\d*(\.\d{1,8})?$').hasMatch(userInput);
  }

}

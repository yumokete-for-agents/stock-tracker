import 'package:yahoofin/yahoofin.dart';
import '../models/stock.dart';
import '../models/stock_fundamentals.dart';
import '../models/stock_snapshot.dart';

class StockService {
  final YahooFin _yf = YahooFin();

  Future<Stock> getStockData(String ticker) async {
    try {
      final tickerClean = ticker.toUpperCase().trim();
      final info = await _yf.getStockInfo(ticker: tickerClean);

      final price = await _yf.getPrice(stockInfo: info);
      final change = await _yf.getPriceChange(stockInfo: info);
      final volume = await _yf.getVolume(stockInfo: info);

      return Stock(
        ticker: tickerClean,
        currentPrice: price.currentPrice,
        change: change.toDouble(),
        changePercent: (change / (price.currentPrice - change)) * 100,
        dayHigh: price.dayHigh,
        dayLow: price.dayLow,
        volume: volume.regularMarketVolume,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      return Stock.empty(ticker.toUpperCase());
    }
  }

  Future<StockFundamentals> getFundamentals(String ticker) async {
    try {
      final tickerClean = ticker.toUpperCase().trim();
      final info = await _yf.getStockInfo(ticker: tickerClean);

      return StockFundamentals(
        ticker: tickerClean,
        trailingPE: info.trailingPE,
        forwardPE: info.forwardPE,
        priceToBook: info.priceToBookRatio,
        epsTrailing: info.epsTrailing12Months,
        epsForward: info.epsForward,
        marketCap: info.marketCap?.toDouble(),
        beta: info.beta,
        dividendYield: info.dividendYield,
        fiftyTwoWeekHigh: info.fiftyTwoWeekHigh,
        fiftyTwoWeekLow: info.fiftyTwoWeekLow,
        avgVolume: info.averageDailyVolume3Month,
        fetchedAt: DateTime.now(),
      );
    } catch (e) {
      return StockFundamentals.empty(ticker.toUpperCase());
    }
  }

  Future<StockSnapshot> getFullSnapshot(String ticker) async {
    final stock = await getStockData(ticker);
    final fundamentals = await getFundamentals(ticker);
    return StockSnapshot.create(
      ticker: ticker,
      stock: stock,
      fundamentals: fundamentals,
    );
  }

  Future<List<Stock>> getMultipleStocks(List<String> tickers) async {
    final stocks = <Stock>[];
    for (final ticker in tickers) {
      final stock = await getStockData(ticker);
      stocks.add(stock);
    }
    return stocks;
  }

  Future<List<StockSnapshot>> getMultipleSnapshots(List<String> tickers) async {
    final snapshots = <StockSnapshot>[];
    for (final ticker in tickers) {
      final snapshot = await getFullSnapshot(ticker);
      snapshots.add(snapshot);
    }
    return snapshots;
  }
}
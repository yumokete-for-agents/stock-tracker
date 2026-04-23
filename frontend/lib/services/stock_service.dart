import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/stock.dart';
import '../models/stock_fundamentals.dart';
import '../models/stock_snapshot.dart';

class StockService {
  static const String _baseUrl = 'query1.finance.yahoo.com';
  static const String _apiStr = '/v7/finance/quote';

  Future<Map<String, dynamic>?> _fetchQuoteData(String ticker) async {
    try {
      final uri = Uri.https(_baseUrl, _apiStr, {'symbols': ticker});
      final response = await http.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () => http.Response('{"error": "timeout"}', 408),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final result = decoded['quoteResponse']?['result'];
        if (result != null && result.isNotEmpty) {
          return result[0] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('Error fetching $ticker: $e');
    }
    return null;
  }

  Future<Stock> getStockData(String ticker) async {
    try {
      final tickerClean = ticker.toUpperCase().trim();
      final data = await _fetchQuoteData(tickerClean);

      if (data == null) {
        return Stock.empty(tickerClean);
      }

      final price = (data['regularMarketPrice'] ?? 0.0).toDouble();
      final change = (data['regularMarketChange'] ?? 0.0).toDouble();
      final changePercent = (data['regularMarketChangePercent'] ?? 0.0).toDouble();

      return Stock(
        ticker: tickerClean,
        currentPrice: price,
        change: change,
        changePercent: changePercent,
        dayHigh: (data['regularMarketDayHigh'] ?? 0.0).toDouble(),
        dayLow: (data['regularMarketDayLow'] ?? 0.0).toDouble(),
        volume: data['regularMarketVolume'] ?? 0,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      return Stock.empty(ticker.toUpperCase());
    }
  }

  Future<StockFundamentals> getFundamentals(String ticker) async {
    try {
      final tickerClean = ticker.toUpperCase().trim();
      final data = await _fetchQuoteData(tickerClean);

      if (data == null) {
        return StockFundamentals.empty(tickerClean);
      }

      return StockFundamentals(
        ticker: tickerClean,
        trailingPE: _toDouble(data['trailingPE']),
        forwardPE: _toDouble(data['forwardPE']),
        priceToBook: _toDouble(data['priceToBook']),
        epsTrailing: _toDouble(data['epsTrailing12Months']),
        epsForward: _toDouble(data['epsForward']),
        marketCap: _toDouble(data['marketCap']),
        beta: _toDouble(data['beta']),
        dividendYield: _toDouble(data['dividendYield']),
        fiftyTwoWeekHigh: _toDouble(data['fiftyTwoWeekHigh']),
        fiftyTwoWeekLow: _toDouble(data['fiftyTwoWeekLow']),
        avgVolume: data['averageDailyVolume3Month'],
        fetchedAt: DateTime.now(),
      );
    } catch (e) {
      return StockFundamentals.empty(ticker.toUpperCase());
    }
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
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
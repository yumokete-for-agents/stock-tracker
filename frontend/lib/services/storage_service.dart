import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stock_snapshot.dart';

class StorageService {
  static const _tickersKey = 'saved_tickers';
  static const _snapshotsPrefix = 'snapshots_';
  static const _historyPrefix = 'history_';
  static const int _maxSnapshotsPerTicker = 30;

  Future<List<String>> getTickers() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_tickersKey);
    return list ?? [];
  }

  Future<void> saveTickers(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_tickersKey, list);
  }

  Future<void> addTicker(String ticker) async {
    final list = await getTickers();
    final tickerUpper = ticker.toUpperCase().trim();
    if (!list.contains(tickerUpper) && tickerUpper.isNotEmpty) {
      list.add(tickerUpper);
      await saveTickers(list);
    }
  }

  Future<void> removeTicker(String ticker) async {
    final list = await getTickers();
    list.remove(ticker.toUpperCase());
    await saveTickers(list);
    await _removeHistory(ticker);
  }

  Future<void> clearTickers() async {
    await saveTickers([]);
  }

  Future<StockSnapshot?> getLatestSnapshot(String ticker) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_snapshotsPrefix${ticker.toUpperCase()}';
    final json = prefs.getString(key);
    if (json == null) return null;
    return StockSnapshot.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveSnapshot(StockSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_snapshotsPrefix${snapshot.ticker.toUpperCase()}';
    await prefs.setString(key, jsonEncode(snapshot.toJson()));
    await _addToHistory(snapshot);
  }

  Future<StockHistory?> getHistory(String ticker) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_historyPrefix${ticker.toUpperCase()}';
    final json = prefs.getString(key);
    if (json == null) return null;
    return StockHistory.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> _addToHistory(StockSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_historyPrefix${snapshot.ticker.toUpperCase()}';

    final StockHistory history = await getHistory(snapshot.ticker) ??
        StockHistory(ticker: snapshot.ticker, snapshots: []);

    history.snapshots.add(snapshot);

    while (history.snapshots.length > _maxSnapshotsPerTicker) {
      history.snapshots.removeAt(0);
    }

    await prefs.setString(key, jsonEncode(history.toJson()));
  }

  Future<void> _removeHistory(String ticker) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_historyPrefix${ticker.toUpperCase()}';
    await prefs.remove(key);
  }

  Future<void> clearAllHistory() async {
    final tickers = await getTickers();
    for (final ticker in tickers) {
      await _removeHistory(ticker);
    }
  }

  Future<Map<String, StockSnapshot>> getAllLatestSnapshots() async {
    final tickers = await getTickers();
    final result = <String, StockSnapshot>{};
    for (final ticker in tickers) {
      final snapshot = await getLatestSnapshot(ticker);
      if (snapshot != null) {
        result[ticker] = snapshot;
      }
    }
    return result;
  }

  Future<Map<String, StockHistory>> getAllHistories() async {
    final tickers = await getTickers();
    final result = <String, StockHistory>{};
    for (final ticker in tickers) {
      final history = await getHistory(ticker);
      if (history != null) {
        result[ticker] = history;
      }
    }
    return result;
  }
}
import 'stock.dart';
import 'stock_fundamentals.dart';

class StockSnapshot {
  final String ticker;
  final Stock stock;
  final StockFundamentals fundamentals;
  final DateTime timestamp;

  StockSnapshot({
    required this.ticker,
    required this.stock,
    required this.fundamentals,
    required this.timestamp,
  });

  factory StockSnapshot.fromJson(Map<String, dynamic> json) {
    return StockSnapshot(
      ticker: json['ticker'] as String,
      stock: Stock.fromJson(json['stock'] as Map<String, dynamic>),
      fundamentals: StockFundamentals.fromJson(
          json['fundamentals'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'stock': stock.toJson(),
      'fundamentals': fundamentals.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory StockSnapshot.create({
    required String ticker,
    required Stock stock,
    required StockFundamentals fundamentals,
  }) {
    return StockSnapshot(
      ticker: ticker,
      stock: stock,
      fundamentals: fundamentals,
      timestamp: DateTime.now(),
    );
  }
}

class StockHistory {
  final String ticker;
  final List<StockSnapshot> snapshots;

  StockHistory({
    required this.ticker,
    required this.snapshots,
  });

  factory StockHistory.fromJson(Map<String, dynamic> json) {
    final snapshotsList = (json['snapshots'] as List)
        .map((s) => StockSnapshot.fromJson(s as Map<String, dynamic>))
        .toList();
    return StockHistory(
      ticker: json['ticker'] as String,
      snapshots: snapshotsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'snapshots': snapshots.map((s) => s.toJson()).toList(),
    };
  }

  StockSnapshot? get latest => snapshots.isEmpty ? null : snapshots.last;

  List<StockSnapshot> lastN(int n) {
    if (snapshots.length <= n) return snapshots;
    return snapshots.sublist(snapshots.length - n);
  }
}
class StockFundamentals {
  final String ticker;
  final double? trailingPE;
  final double? forwardPE;
  final double? priceToBook;
  final double? epsTrailing;
  final double? epsForward;
  final double? marketCap;
  final double? revenue;
  final double? netIncome;
  final double? beta;
  final double? dividendYield;
  final double? fiftyTwoWeekHigh;
  final double? fiftyTwoWeekLow;
  final double? avgVolume;
  final DateTime fetchedAt;

  StockFundamentals({
    required this.ticker,
    this.trailingPE,
    this.forwardPE,
    this.priceToBook,
    this.epsTrailing,
    this.epsForward,
    this.marketCap,
    this.revenue,
    this.netIncome,
    this.beta,
    this.dividendYield,
    this.fiftyTwoWeekHigh,
    this.fiftyTwoWeekLow,
    this.avgVolume,
    required this.fetchedAt,
  });

  factory StockFundamentals.empty(String ticker) {
    return StockFundamentals(
      ticker: ticker,
      fetchedAt: DateTime.now(),
    );
  }

  factory StockFundamentals.fromJson(Map<String, dynamic> json) {
    return StockFundamentals(
      ticker: json['ticker'] as String,
      trailingPE: _toDouble(json['trailingPE']),
      forwardPE: _toDouble(json['forwardPE']),
      priceToBook: _toDouble(json['priceToBook']),
      epsTrailing: _toDouble(json['epsTrailing']),
      epsForward: _toDouble(json['epsForward']),
      marketCap: _toDouble(json['marketCap']),
      revenue: _toDouble(json['revenue']),
      netIncome: _toDouble(json['netIncome']),
      beta: _toDouble(json['beta']),
      dividendYield: _toDouble(json['dividendYield']),
      fiftyTwoWeekHigh: _toDouble(json['fiftyTwoWeekHigh']),
      fiftyTwoWeekLow: _toDouble(json['fiftyTwoWeekLow']),
      avgVolume: _toDouble(json['avgVolume']),
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'trailingPE': trailingPE,
      'forwardPE': forwardPE,
      'priceToBook': priceToBook,
      'epsTrailing': epsTrailing,
      'epsForward': epsForward,
      'marketCap': marketCap,
      'revenue': revenue,
      'netIncome': netIncome,
      'beta': beta,
      'dividendYield': dividendYield,
      'fiftyTwoWeekHigh': fiftyTwoWeekHigh,
      'fiftyTwoWeekLow': fiftyTwoWeekLow,
      'avgVolume': avgVolume,
      'fetchedAt': fetchedAt.toIso8601String(),
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
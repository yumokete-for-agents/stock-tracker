import 'package:flutter/material.dart';
import '../models/stock_fundamentals.dart';

class FundamentalsPanel extends StatelessWidget {
  final StockFundamentals fundamentals;
  final bool expanded;

  const FundamentalsPanel({
    super.key,
    required this.fundamentals,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fundamentales',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _RatioItem('P/E', fundamentals.trailingPE),
              _RatioItem('P/E Fwd', fundamentals.forwardPE),
              _RatioItem('P/B', fundamentals.priceToBook),
              _RatioItem('EPS', fundamentals.epsTrailing),
              _RatioItem('EPS Fwd', fundamentals.epsForward),
              _RatioItem('Beta', fundamentals.beta),
              _RatioItem('Div. Yield', fundamentals.dividendYield, suffix: '%'),
              _RatioItem('MCap', _formatMarketCap(fundamentals.marketCap)),
              _RatioItem('52W High', fundamentals.fiftyTwoWeekHigh),
              _RatioItem('52W Low', fundamentals.fiftyTwoWeekLow),
              _RatioItem('Vol (3M)', _formatVolume(fundamentals.avgVolume)),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 8),
            Text(
              'Actualizado: ${_formatDate(fundamentals.fetchedAt)}',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  String _formatMarketCap(double? value) {
    if (value == null) return '-';
    if (value >= 1e12) return '\$${(value / 1e12).toStringAsFixed(1)}T';
    if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(1)}B';
    if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(1)}M';
    return '\$${value.toStringAsFixed(0)}';
  }

  String _formatVolume(double? value) {
    if (value == null) return '-';
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}B';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
    if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _RatioItem extends StatelessWidget {
  final String label;
  final double? value;
  final String suffix;

  const _RatioItem(this.label, this.value, {this.suffix = ''});

  @override
  Widget build(BuildContext context) {
    final display = value != null ? value!.toStringAsFixed(2) : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
        Text(
          '$display$suffix',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
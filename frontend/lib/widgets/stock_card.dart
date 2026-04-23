import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../models/stock_fundamentals.dart';
import '../widgets/fundamentals_panel.dart';

class StockCard extends StatelessWidget {
  final Stock stock;
  final StockFundamentals? fundamentals;
  final VoidCallback? onDelete;
  final bool showFundamentals;

  const StockCard({
    super.key,
    required this.stock,
    this.fundamentals,
    this.onDelete,
    this.showFundamentals = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = stock.change >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.ticker,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${stock.currentPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isPositive ? '+' : ''}\$${stock.change.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: changeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${isPositive ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 16,
                          color: changeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vol: ${_formatVolume(stock.volume)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                  ),
              ],
            ),
            if (showFundamentals && fundamentals != null) ...[
              const SizedBox(height: 12),
              FundamentalsPanel(fundamentals: fundamentals!),
            ],
          ],
        ),
      ),
    );
  }

  String _formatVolume(int volume) {
    if (volume >= 1000000000) {
      return '${(volume / 1000000000).toStringAsFixed(1)}B';
    } else if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    }
    return volume.toString();
  }
}
import 'package:flutter/material.dart';
import '../models/stock_snapshot.dart';
import '../services/stock_service.dart';
import '../services/storage_service.dart';
import '../widgets/stock_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tickerController = TextEditingController();
  final _stockService = StockService();
  final _storageService = StorageService();

  List<String> _tickers = [];
  Map<String, StockSnapshot> _snapshots = {};
  bool _isLoading = false;
  bool _isFetching = false;
  bool _showFundamentals = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _tickerController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _tickers = await _storageService.getTickers();
    _snapshots = await _storageService.getAllLatestSnapshots();
    setState(() => _isLoading = false);
  }

  Future<void> _addTicker() async {
    final ticker = _tickerController.text.trim();
    if (ticker.isEmpty) return;

    await _storageService.addTicker(ticker);
    _tickerController.clear();
    _tickers = await _storageService.getTickers();
    setState(() {});
  }

  Future<void> _removeTicker(String ticker) async {
    await _storageService.removeTicker(ticker);
    _tickers = await _storageService.getTickers();
    _snapshots.remove(ticker.toUpperCase());
    setState(() {});
  }

  Future<void> _fetchAllStocks() async {
    if (_tickers.isEmpty || _isFetching) return;

    setState(() => _isFetching = true);

    for (final ticker in _tickers) {
      try {
        final snapshot = await _stockService.getFullSnapshot(ticker);
        await _storageService.saveSnapshot(snapshot);
        _snapshots[ticker] = snapshot;
      } catch (e) {
        debugPrint('Error fetching $ticker: $e');
      }
    }

    setState(() => _isFetching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showFundamentals ? Icons.analytics : Icons.analytics_outlined,
            ),
            onPressed: () {
              setState(() => _showFundamentals = !_showFundamentals);
            },
            tooltip: 'Mostrar fundamentales',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tickerController,
                    decoration: const InputDecoration(
                      hintText: 'Ingresa ticker (e.g., AAPL)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onSubmitted: (_) => _addTicker(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTicker,
                  child: const Text('Añadir'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _tickers.isEmpty || _isFetching ? null : _fetchAllStocks,
                icon: _isFetching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: Text(_isFetching ? 'Actualizando...' : 'Descargar Precios'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _snapshots.isEmpty && _tickers.isEmpty
                    ? const Center(
                        child: Text(
                          'Añade tickers para comenzar',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tickers.length,
                        itemBuilder: (context, index) {
                          final ticker = _tickers[index];
                          final snapshot = _snapshots[ticker];

                          if (snapshot != null) {
                            return StockCard(
                              stock: snapshot.stock,
                              fundamentals: snapshot.fundamentals,
                              onDelete: () => _removeTicker(ticker),
                              showFundamentals: _showFundamentals,
                            );
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              title: Text(ticker),
                              subtitle: const Text('Sin datos - pulsaDescargar'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _removeTicker(ticker),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:uas/pages/update/updateStock.dart';
import 'package:uas/services/api_service.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late Future<List<dynamic>> _stocks;

  @override
  void initState() {
    super.initState();
    _stocks = ApiService.fetchstocks();
  }

  Future<void> _refreshstocks() async {
    setState(() {
      _stocks = ApiService.fetchstocks();
    });
  }

  Future<void> _deletestock(String id) async {
    try {
      await ApiService.deletestock(id);
      _refreshstocks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete stock')),
      );
    }
  }

  void _updatestock(Map<String, dynamic> stock) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UpdatestockPage(stock: stock)),
    );
    if (result == true) {
      _refreshstocks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            alignment: Alignment.centerLeft,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.storage,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Berkah Rasa',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      'Stocks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _stocks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load stocks'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No stocks available'));
                } else {
                  // Filter stocks where issuer == 'jalal'
                  final filteredstocks = snapshot.data!
                      .where((stock) => stock['issuer'] == 'jalal')
                      .toList();

                  if (filteredstocks.isEmpty) {
                    return Center(
                        child: Text('No stocks available for issuer: jalal'));
                  }

                  return ListView.builder(
                    itemCount: filteredstocks.length,
                    itemBuilder: (context, index) {
                      final stock = filteredstocks[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(stock['name']),
                          subtitle: Text(
                              "${stock['qty'].toString()} ${stock['attr']}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => _deletestock(stock['id']),
                          ),
                          onTap: () => _updatestock(stock),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

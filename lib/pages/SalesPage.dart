import 'package:flutter/material.dart';
import 'package:uas/pages/update/updateSale.dart';
import 'package:uas/services/api_service.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  late Future<List<dynamic>> _sales;

  @override
  void initState() {
    super.initState();
    _sales = ApiService.fetchsales();
  }

  Future<void> _refreshsales() async {
    setState(() {
      _sales = ApiService.fetchsales();
    });
  }

  Future<void> _deletesale(String id) async {
    try {
      await ApiService.deletesale(id);
      _refreshsales();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete sale')),
      );
    }
  }

  void _updatesale(Map<String, dynamic> sale) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UpdatesalePage(sale: sale)),
    );
    if (result == true) {
      _refreshsales();
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
                  Icons.attach_money,
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
                      'Sales',
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
              future: _sales,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load sales'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No sales available'));
                } else {
                  // Filter sales where issuer == 'jalal'
                  final filteredsales = snapshot.data!
                      .where((sale) => sale['issuer'] == 'jalal')
                      .toList();

                  if (filteredsales.isEmpty) {
                    return Center(
                        child: Text('No sales available for issuer: jalal'));
                  }

                  return ListView.builder(
                    itemCount: filteredsales.length,
                    itemBuilder: (context, index) {
                      final sale = filteredsales[index];
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
                          title: Text(sale['buyer']),
                          subtitle: Text(
                              "${sale['status']} | ${sale['date']}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => _deletesale(sale['id']),
                          ),
                          onTap: () => _updatesale(sale),
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

import 'package:flutter/material.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> items;
  final int tableNumber;
  final Function(Map<String, dynamic>) onItemAdded;

  const CategoryItemsScreen({
    super.key,
    required this.categoryName,
    required this.items,
    required this.tableNumber,
    required this.onItemAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName - Mesa $tableNumber'),
        backgroundColor: const Color(0xFF6A0DAD),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildItemCard(context, item);
        },
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item['name']),
        trailing: Text(
          'R\$${item['price'].toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => _showAddItemDialog(context, item),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, Map<String, dynamic> item) {
    final TextEditingController quantityController = TextEditingController(
      text: '1',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Adicionar ${item['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Preço unitário: R\$${item['price'].toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0DAD),
                ),
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text) ?? 1;
                  onItemAdded({
                    'name': item['name'],
                    'price': item['price'],
                    'quantity': quantity,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$quantity ${item['name']} adicionado(s)'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'Adicionar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}

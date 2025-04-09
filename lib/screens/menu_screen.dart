import 'package:flutter/material.dart';
import 'category_items_screen.dart';
import 'bill_screen.dart';

class MenuScreen extends StatefulWidget {
  final int tableNumber;

  const MenuScreen({super.key, required this.tableNumber});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> _currentOrders = [];

  void _addToOrder(Map<String, dynamic> item) {
    setState(() {
      // Verifica se o item já existe no pedido
      final existingIndex = _currentOrders.indexWhere(
        (order) => order['name'] == item['name'],
      );

      if (existingIndex >= 0) {
        // Atualiza quantidade se já existir
        _currentOrders[existingIndex]['quantity'] += item['quantity'];
      } else {
        // Adiciona novo item ao pedido
        _currentOrders.add(Map.from(item));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesa ${widget.tableNumber} - Cardápio'),
        backgroundColor: const Color(0xFF6A0DAD),
        actions: [
          // Ícone para visualizar pedidos atuais
          IconButton(
            icon: Badge(
              label: Text(_currentOrders.length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              if (_currentOrders.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nenhum item adicionado ainda')),
                );
                return;
              }
              _showCurrentOrders(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoryCard(
            context,
            'Refrigerantes',
            Icons.local_drink,
            const Color(0xFF6A0DAD),
            items: [
              {'name': 'Coca-Cola', 'price': 7.00},
              {'name': 'Guaraná', 'price': 6.50},
              {'name': 'Fanta', 'price': 6.50},
            ],
          ),
          _buildCategoryCard(
            context,
            'Bebidas Alcoólicas',
            Icons.wine_bar,
            const Color(0xFFB399D4),
            items: [
              {'name': 'Cerveja IPA', 'price': 12.00},
              {'name': 'Vinho Tinto', 'price': 25.00},
              {'name': 'Whisky', 'price': 18.00},
            ],
          ),
          _buildCategoryCard(
            context,
            'Pratos Frios',
            Icons.icecream,
            Colors.blue,
            items: [
              {'name': 'Salada Caesar', 'price': 22.00},
              {'name': 'Bruschetta', 'price': 18.00},
            ],
          ),
          _buildCategoryCard(
            context,
            'Pratos Quentes',
            Icons.restaurant,
            Colors.red,
            items: [
              {'name': 'Pizza Margherita', 'price': 45.00},
              {'name': 'Lasanha', 'price': 38.00},
            ],
          ),
          _buildCategoryCard(
            context,
            'Sobremesas',
            Icons.cake,
            Colors.orange,
            items: [
              {'name': 'Petit Gateau', 'price': 18.00},
              {'name': 'Sorvete', 'price': 12.00},
            ],
          ),
          const SizedBox(height: 20),
          _buildViewBillCard(context),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color, {
    required List<Map<String, dynamic>> items,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => CategoryItemsScreen(
                    categoryName: title,
                    items: items,
                    tableNumber: widget.tableNumber,
                    onItemAdded: _addToOrder,
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildViewBillCard(BuildContext context) {
    return Card(
      color: const Color(0xFF6A0DAD).withOpacity(0.1),
      child: ListTile(
        leading: const Icon(Icons.receipt, color: Color(0xFF6A0DAD)),
        title: const Text(
          'Visualizar Conta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A0DAD),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Color(0xFF6A0DAD)),
        onTap: () {
          if (_currentOrders.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Adicione itens antes de visualizar a conta'),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BillScreen(
                    tableNumber: widget.tableNumber,
                    orders: _currentOrders,
                  ),
            ),
          );
        },
      ),
    );
  }

  void _showCurrentOrders(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Pedidos Atuais'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _currentOrders.length,
                itemBuilder: (context, index) {
                  final item = _currentOrders[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text(
                      '${item['quantity']} x R\$${item['price'].toStringAsFixed(2)}',
                    ),
                    trailing: Text(
                      'R\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          ),
    );
  }
}

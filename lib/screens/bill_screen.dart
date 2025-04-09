import 'package:flutter/material.dart';

class BillScreen extends StatefulWidget {
  final int tableNumber;
  final List<Map<String, dynamic>> orders;

  const BillScreen({
    super.key,
    required this.tableNumber,
    required this.orders,
  });

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  late List<Map<String, dynamic>> _orders;
  final double _serviceTax = 0.10;
  int _splitBetween = 1;

  @override
  void initState() {
    super.initState();
    _orders =
        widget.orders.map((item) {
          return {
            'name': item['name']?.toString() ?? 'Item sem nome',
            'price': (item['price'] as num).toDouble(),
            'quantity': (item['quantity'] as int?) ?? 1,
          };
        }).toList();
  }

  double get _subtotal =>
      _orders.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  double get _totalWithTax => _subtotal * (1 + _serviceTax);
  double get _splitValue => _totalWithTax / _splitBetween;

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        _orders[index]['quantity'] = newQuantity;
      } else {
        _orders.removeAt(index);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Item removido da conta')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conta - Mesa ${widget.tableNumber}'),
        backgroundColor: const Color(0xFF6A0DAD),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _orders.isEmpty
                    ? const Center(child: Text('Nenhum item adicionado'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final item = _orders[index];
                        return _buildOrderItem(item, index);
                      },
                    ),
          ),
          _buildBillSummary(),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item, int index) {
    final totalItem = item['price'] * item['quantity'];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item['name']),
        subtitle: Text(
          '${item['quantity']} x R\$${item['price'].toStringAsFixed(2)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'R\$${totalItem.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditDialog(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          _buildTotalRow('Subtotal:', _subtotal),
          _buildTotalRow('Taxa de Serviço (10%):', _subtotal * _serviceTax),
          const Divider(height: 24),
          _buildTotalRow('TOTAL:', _totalWithTax, isTotal: true),
          if (_splitBetween > 1) ...[
            const SizedBox(height: 8),
            Text(
              '→ ${_splitBetween}x de R\$${_splitValue.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF6A0DAD),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showSplitDialog(),
            child: const Text('DIVIDIR CONTA'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A0DAD),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed:
                _orders.isEmpty
                    ? null
                    : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Conta da Mesa ${widget.tableNumber} encerrada!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
            child: const Text(
              'FECHAR CONTA',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditDialog(int index) {
    final TextEditingController quantityController = TextEditingController(
      text: _orders[index]['quantity'].toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Editar ${_orders[index]['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Preço unitário: R\$${_orders[index]['price'].toStringAsFixed(2)}',
                ),
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
                onPressed: () {
                  final newQuantity =
                      int.tryParse(quantityController.text) ?? 1;
                  _updateQuantity(index, newQuantity);
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
    );
  }

  void _showSplitDialog() {
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Dividir Conta'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Dividir entre quantas pessoas?'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (_splitBetween > 1) {
                              setState(() => _splitBetween--);
                            }
                          },
                        ),
                        Text(
                          '$_splitBetween',
                          style: const TextStyle(fontSize: 24),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() => _splitBetween++);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Valor por pessoa: R\$${(_totalWithTax / _splitBetween).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                      Navigator.pop(context);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Conta dividida entre $_splitBetween pessoa(s)',
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
          Text(
            'R\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
              color: isTotal ? const Color(0xFF6A0DAD) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

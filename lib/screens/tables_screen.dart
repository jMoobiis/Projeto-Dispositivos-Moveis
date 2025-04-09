import 'package:flutter/material.dart';
import 'menu_screen.dart'; // Importe a tela de menu

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  // Estado das mesas
  final List<Map<String, dynamic>> tables = [
    {'number': 1, 'status': 0, 'order': null, 'reservationInfo': null},
    {'number': 2, 'status': 1, 'order': 'Pedido #123', 'reservationInfo': null},
    {'number': 3, 'status': 0, 'order': null, 'reservationInfo': null},
    {
      'number': 4,
      'status': 2,
      'order': 'Reserva - 20:00',
      'reservationInfo': 'Cliente: João, Horário: 20:00',
    },
    {'number': 5, 'status': 0, 'order': null, 'reservationInfo': null},
  ];

  // Cores e textos de status
  static const Map<int, Color> statusColors = {
    0: Colors.green, // Disponível
    1: Colors.red, // Ocupada
    2: Colors.orange, // Reservada
  };

  static const Map<int, String> statusText = {
    0: 'Disponível',
    1: 'Ocupada',
    2: 'Reservada',
  };

  final TextEditingController _reservationNameController =
      TextEditingController();
  final TextEditingController _reservationTimeController =
      TextEditingController();

  @override
  void dispose() {
    _reservationNameController.dispose();
    _reservationTimeController.dispose();
    super.dispose();
  }

  void _handleTableTap(int tableNumber, int currentStatus) {
    showDialog(
      context: context,
      builder: (context) => _buildTableDialog(tableNumber, currentStatus),
    );
  }

  Widget _buildTableDialog(int tableNumber, int currentStatus) {
    final table = tables.firstWhere((t) => t['number'] == tableNumber);

    return AlertDialog(
      title: Text('Mesa $tableNumber'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status atual: ${statusText[currentStatus]}'),
          if (table['reservationInfo'] != null) ...[
            const SizedBox(height: 8),
            Text(
              table['reservationInfo'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
      actions: [
        if (currentStatus == 0) ...[
          _buildDialogButton(
            'Reservar Mesa',
            Colors.blue,
            () => _showReservationDialog(tableNumber),
          ),
          _buildDialogButton('Ocupar Mesa', null, () {
            _changeTableStatus(tableNumber, 1);
            Navigator.pop(context);
            _navigateToMenuScreen(tableNumber);
          }),
        ],
        if (currentStatus == 1)
          _buildDialogButton(
            'Liberar Mesa',
            null,
            () => _changeTableStatus(tableNumber, 0),
          ),
        if (currentStatus == 2)
          _buildDialogButton(
            'Cancelar Reserva',
            Colors.red,
            () => _showCancelReservationDialog(tableNumber),
          ),
        _buildDialogButton('Fechar', null, () => Navigator.pop(context)),
      ],
    );
  }

  Widget _buildDialogButton(String text, Color? color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: color != null ? TextStyle(color: color) : null),
    );
  }

  void _navigateToMenuScreen(int tableNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(tableNumber: tableNumber),
      ),
    );
  }

  void _showReservationDialog(int tableNumber) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Reservar Mesa $tableNumber'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _reservationNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Cliente',
                  ),
                ),
                TextField(
                  controller: _reservationTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Horário (ex: 20:00)',
                  ),
                ),
              ],
            ),
            actions: [
              _buildDialogButton(
                'Cancelar',
                null,
                () => Navigator.pop(context),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_reservationNameController.text.isNotEmpty &&
                      _reservationTimeController.text.isNotEmpty) {
                    _reserveTable(tableNumber);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Confirmar Reserva'),
              ),
            ],
          ),
    );
  }

  void _reserveTable(int tableNumber) {
    setState(() {
      final table = tables.firstWhere((t) => t['number'] == tableNumber);
      table['status'] = 2;
      table['reservationInfo'] =
          'Cliente: ${_reservationNameController.text}, '
          'Horário: ${_reservationTimeController.text}';
      table['order'] = 'Reserva - ${_reservationTimeController.text}';
    });

    _clearReservationFields();

    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar('Mesa $tableNumber reservada com sucesso!', Colors.blue),
    );
  }

  void _clearReservationFields() {
    _reservationNameController.clear();
    _reservationTimeController.clear();
  }

  void _showCancelReservationDialog(int tableNumber) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancelar Reserva'),
            content: Text(
              'Tem certeza que deseja cancelar a reserva da Mesa $tableNumber?',
            ),
            actions: [
              _buildDialogButton('Voltar', null, () => Navigator.pop(context)),
              _buildDialogButton('Confirmar', Colors.red, () {
                _cancelReservation(tableNumber);
                Navigator.pop(context);
                Navigator.pop(context);
              }),
            ],
          ),
    );
  }

  void _cancelReservation(int tableNumber) {
    setState(() {
      final table = tables.firstWhere((t) => t['number'] == tableNumber);
      table['status'] = 0;
      table['order'] = null;
      table['reservationInfo'] = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar('Reserva da Mesa $tableNumber cancelada!', Colors.green),
    );
  }

  SnackBar _buildSnackBar(String message, Color color) {
    return SnackBar(content: Text(message), backgroundColor: color);
  }

  void _changeTableStatus(int tableNumber, int newStatus) {
    setState(() {
      final table = tables.firstWhere((t) => t['number'] == tableNumber);
      table['status'] = newStatus;
      table['order'] =
          newStatus == 1
              ? 'Novo Pedido #${DateTime.now().millisecondsSinceEpoch}'
              : null;
    });

    if (newStatus != 1) {
      Navigator.pop(context);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(
        'Mesa $tableNumber atualizada para ${statusText[newStatus]}',
        statusColors[newStatus]!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesas Disponíveis'),
        backgroundColor: const Color(0xFF6A0DAD),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: tables.length,
        itemBuilder: (context, index) => _buildTableCard(tables[index]),
      ),
    );
  }

  Widget _buildTableCard(Map<String, dynamic> table) {
    final status = table['status'] as int;

    return GestureDetector(
      onTap: () => _handleTableTap(table['number'], status),
      child: Card(
        elevation: 4,
        color: statusColors[status]!.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: statusColors[status]!, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mesa ${table['number']}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: statusColors[status],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                statusText[status]!,
                style: TextStyle(color: statusColors[status]),
              ),
              if (table['order'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  table['order'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

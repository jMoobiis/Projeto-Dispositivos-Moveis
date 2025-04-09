import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'tables_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            color: const Color.fromARGB(255, 240, 237, 237),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Menu Principal',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
            context,
            'Mesas',
            Icons.table_restaurant,
            const Color(0xFF6A0DAD),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TablesScreen()),
              );
            },
          ),
          _buildFeatureCard(
            context,
            'Funcionalidade 2',
            Icons.shopping_cart,
            const Color(0xFFB399D4),
            onTap: () {
              // Adicione a navegação para Funcionalidade 2 aqui
            },
          ),
          _buildFeatureCard(
            context,
            'Funcionalidade 3',
            Icons.settings,
            const Color(0xFF6A0DAD),
            onTap: () {
              // Adicione a navegação para Funcionalidade 3 aqui
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color, {
    VoidCallback? onTap, // Parâmetro opcional adicionado aqui
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap, // Usando o parâmetro onTap recebido
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o App')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sobre o Projeto',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A0DAD),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Este aplicativo foi desenvolvido como parte do projeto prático de Flutter.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'Objetivo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Criar uma aplicação multiplataforma com funcionalidades básicas '
              'como autenticação, cadastro e recuperação de senha, além de '
              'funcionalidades específicas de acordo com o tema escolhido.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'Desenvolvedor:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '• João Victor Mobiglia Podenciano\n',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Versão 1.0.0',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

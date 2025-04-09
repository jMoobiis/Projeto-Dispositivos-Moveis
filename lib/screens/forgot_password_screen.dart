import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/dialog_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _recoverPassword() async {
    if (_emailController.text.isEmpty) {
      DialogUtils.showAlertDialog(
        context,
        'Erro',
        'Por favor, digite seu e-mail',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simular recuperação de senha
      await Future.delayed(const Duration(seconds: 1));

      DialogUtils.showSnackBar(
        context,
        'E-mail de recuperação enviado para ${_emailController.text}',
      );

      Navigator.pop(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Digite seu e-mail para recuperar a senha',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: _emailController,
              label: 'E-mail',
              hint: 'Digite seu e-mail cadastrado',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Recuperar Senha',
              onPressed: _recoverPassword,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

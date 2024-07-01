import 'package:flutter/material.dart';
import '../services/authentication_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  Future<void> _resetPassword() async {
    try {
      await _authService.resetPassword(_emailController.text.trim());
      _showResetPasswordConfirmationDialog();
    } catch (e) {
      _showErrorDialog('Erro ao Redefinir Senha', 'Ocorreu um erro ao enviar o email de redefinição de senha: $e');
    }
  }

  void _showResetPasswordConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email de Redefinição Enviado'),
          content: Text('Um email de redefinição de senha foi enviado para ${_emailController.text}.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Voltar para a tela de login
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Espaço para o logo (pode ser o mesmo que na tela de login)
                Image.asset(
                  'assets/logo.png',
                  height: 150,
                ),
                const SizedBox(height: 30.0),
                const Text(
                  'Esqueceu sua senha?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Digite seu email para receber instruções de recuperação de senha.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Enviar Instruções'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:db_sqlite/ui/mobile/home.dart';
import 'package:db_sqlite/ui/widgets/menssagens.dart';
import 'package:db_sqlite/ui/widgets/recuperacao_senha.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/auth_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  final _userController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AuthViewModel>(context);

    switch (store.estadoAuth) {
      case EstadoAuth.inicial:
        break;
      case EstadoAuth.logando:
        return Center(child: CircularProgressIndicator());
      case EstadoAuth.logado:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        });
        break;
      case EstadoAuth.erro:
        mostrarSnackBar(
          context: context,
          mensagem: store.mensagemErro!,
          limparerro: store.limparErro,
          cor: Colors.red,
        );
        break;
    }

    // if (store.estadoAuth == EstadoAuth.erro && store.mensagemErro != null) {
    //   mostrarSnackBar(
    //     context: context,
    //     mensagem: store.mensagemErro!,
    //     limparerro: store.limparErro,
    //     cor: Colors.red,
    //   );
    // } else if (store.estadoAuth == EstadoAuth.logado) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => HomePage()),
    //     );
    //   });
    // } else if (store.estadoAuth == EstadoAuth.logando) {
    //   return Center(child: CircularProgressIndicator());
    // }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203A43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_balance_wallet_rounded,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'ESTUDO DO TIAGO',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Controle seus gastos de forma inteligente',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: _userController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Usuário',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Informe o usuário' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: _senhaController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Informe a senha' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            await store.login(
                              _userController.text,
                              _senhaController.text,
                            );
                          },
                          icon: const Icon(Icons.login),
                          label: const Text('Entrar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1DB954),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 8),
                      TextButton(
                        // onPressed: () => FirebaseCrashlytics.instance.crash(),
                        // child: const Text('Forçar erro de crash...'),
                        onPressed:
                            () => showDialog(
                              context: context,
                              builder: (context) => RecuperacaoSenha(),
                            ),
                        child: const Text(
                          'Recuperar senha',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

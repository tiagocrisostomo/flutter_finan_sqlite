import 'package:flutter/material.dart';

void mostrarSnackBar({
  required BuildContext context,
  required String mensagem,
  Color cor = Colors.green,
  required void Function() limparerro,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 55),
        duration: Duration(seconds: 2),
        content: Text(mensagem),
        backgroundColor: cor,
        showCloseIcon: true,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 10,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
    limparerro.call();
  });
}

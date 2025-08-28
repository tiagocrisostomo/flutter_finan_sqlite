import 'dart:ui';

Color corAleatoria(String chave) {
    final hash = chave.hashCode;
    return Color((0xFF000000 + (hash & 0x00FFFFFF))).withValues(alpha: 1.0);
  }

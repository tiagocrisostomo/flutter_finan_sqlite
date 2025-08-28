import 'package:db_sqlite/ui/desktop/login_screen_desktop.dart';
import 'package:db_sqlite/ui/mobile/login_screen.dart';
import 'package:db_sqlite/ui/widgets/build_responsivo.dart';
import 'package:db_sqlite/viewmodel/trocar_tema_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class Aplicacao extends StatelessWidget {
  const Aplicacao({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<TrocarTemaViewModel>(context);
    return MaterialApp(
      // Suporte à localização para português do Brasil
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      // Define a tela inicial de acordo com o dispositivo
      home: BuildResponsivo(
        desktop: LoginScreenDesktop(),
        mobile: LoginScreen(),
        tablet: LoginScreen(),
      ),
      // Título da aplicação
      title: 'Login',
      // Tema da aplicação com Material 3 e cores personalizadas
      themeMode: store.temaAtual,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: Colors.green.shade400,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.green.shade600,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black26,
          showUnselectedLabels: false,
        ),
        appBarTheme: AppBarTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.green.shade600),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          showCloseIcon: true,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 8.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 10,
          dismissDirection: DismissDirection.horizontal,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.green.shade600,
          selectedItemColor: Colors.black26,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            foregroundColor: WidgetStatePropertyAll(Colors.black),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}

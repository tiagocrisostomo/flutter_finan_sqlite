# 📱 Flutter SQLite Modular App

Um projeto de referência em Flutter para gerenciamento de dados de finanças. A aplicação permite operações `CRUD` em 'tipos de finanças', utiliza `SQLite` como banco de dados local e implementa uma arquitetura com `DAO` e `Service`. O estado é gerenciado com o `Provider/ChangeNotifier`, e a UI exibe os dados de forma otimizada com `Lazy Loading`.

---

## 🚀 Tecnologias Utilizadas

## [![flutter version](https://img.shields.io/badge/flutter%20%20-blue?style=for-the-badge&logo=flutter)](https://flutter.dev/) [![sqllite version](https://img.shields.io/badge/sqlite%20%20-darkblue?style=for-the-badge&logo=Sqlite)](https://sqlite.org/)

- **Flutter**
- **SQLite** com `sqflite`
- **Provider** (`ChangeNotifier`)
---

## 📂 Estrutura de Pastas

```bash
lib/
├── data
│   ├── banco_de_dados.dart
│   ├── interface
│   │   ├── finan_categoria_dao.dart
│   │   ├── finan_categoria_dao_impl.dart
│   │   ├── finan_lancamento_dao.dart
│   │   ├── finan_lancamento_dao_impl.dart
│   │   ├── finan_tipo_dao.dart
│   │   ├── finan_tipo_dao_impl.dart
│   │   ├── usuario_dao.dart
│   │   └── usuario_dao_impl.dart
│   ├── model
│   │   ├── finan_categoria.dart
│   │   ├── finan_lancamento.dart
│   │   ├── finan_tipo.dart
│   │   └── usuario.dart
│   ├── seed.dart
│   └── service
│       ├── auth_service.dart
│       ├── finan_categoria_service.dart
│       ├── finan_lancamento_service.dart
│       ├── finan_tipo_service.dart
│       └── usuario_service.dart
├── firebase_options.dart
├── main_app.dart
├── main.dart
├── ui
│   ├── view
│   │   ├── desktop
│   │   │   ├── configuracao_screen_desktop.dart
│   │   │   ├── finan_categoria_screen_desktop.dart
│   │   │   ├── finan_lancamento_screen_desktop.dart
│   │   │   ├── finan_tipo_screen_desktop.dart
│   │   │   ├── home_desktop.dart
│   │   │   ├── login_screen_desktop.dart
│   │   │   └── usuario_screen desktop.dart
│   │   └── mobile
│   │       ├── configuracao_screen.dart
│   │       ├── finan_categoria_screen.dart
│   │       ├── finan_lancamento_screen.dart
│   │       ├── finan_lancamento_screen_todos.dart
│   │       ├── finan_tipo_screen.dart
│   │       ├── home.dart
│   │       ├── login_screen.dart
│   │       └── usuario_screen.dart
│   ├── viewmodel
│   │   ├── auth_viewmodel.dart
│   │   ├── conectividade_check_viewmodel.dart
│   │   ├── finan_categoria_viewmodel.dart
│   │   ├── finan_lancamento_viewmodel.dart
│   │   ├── finan_tipo_viewmodel.dart
│   │   ├── trocar_tema_viewmodel.dart
│   │   └── usuario_viewmodel.dart
│   └── widget
│       ├── build_responsivo.dart
│       ├── finan_categoria_form.dart
│       ├── finan_lancamento_form.dart
│       ├── finan_painel.dart
│       ├── finan_tipo_form.dart
│       ├── menssagens.dart
│       ├── recuperacao_senha.dart
│       └── usuario_form.dart
└── util
    ├── agrupar_lancamentos_por_mes.dart
    ├── cores_aleatorias.dart
    ├── dispositivo_tela_tipo.dart
    ├── inicializacao.dart
    ├── logger_service.dart
    ├── routes_context_transations.dart
    └── seguranca.dart
```

## 🧠 Conceitos Aplicados
✅ Separação de responsabilidades
✅ Persistência local com SQLite
✅ Lógica de negócio isolada (Service)
✅ Interface reativa com ChangeNotifier
✅ Estados de carregamento e erro
✅ SnackBar para feedback de erros

# Clone o repositório
git clone https://git@github.com:tiagocrisostomo/flutter_finan_sqlite.git

# Navegue até a pasta
cd flutter_finan_sqlite

# Instale as dependências
flutter pub get

# Execute o app
flutter run

## 📸 Demo Funcionamento
https://github.com/user-attachments/assets/9d975aaf-472a-4e6b-ba2b-b9d289ae3cc1

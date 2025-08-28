import 'package:db_sqlite/model/finan_tipo.dart';
import 'package:db_sqlite/viewmodel/finan_tipo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class FormularioFinanTipo extends StatefulWidget {
  final FinanTipo? tipo;
  const FormularioFinanTipo({super.key, this.tipo});

  @override
  State<FormularioFinanTipo> createState() => _FormularioFinanTipoState();
}

class _FormularioFinanTipoState extends State<FormularioFinanTipo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.tipo?.descricao ?? '');
    // _corSelecionada = widget.tipo?.cor ?? '#FF0000';
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanTipoViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastrar/Alterar Tipo(s)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 8),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.type_specimen_rounded),
                ),
                validator:
                    (v) =>
                        v == null || v.isEmpty ? 'Informe a descrição' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Salvar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Adicione a lógica para salvar o tipo aqui
                    await store.adicionarTipo(
                      FinanTipo(
                        id: widget.tipo?.id,
                        descricao: _nomeController.text.trim(),
                      ),
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // fecha o BottomSheet
                  }
                },
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

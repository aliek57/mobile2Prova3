import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile2prova3/model/anuncio.dart';
import 'package:mobile2prova3/model/modelo.dart';
import 'package:mobile2prova3/ui/viewmodels/BuscaViewModel.dart';

class TelaBusca extends StatefulWidget {
  const TelaBusca({super.key});

  @override
  State<TelaBusca> createState() => _TelaBuscaState();
}

class _TelaBuscaState extends State<TelaBusca> {
  late TextEditingController _anoInicialController;
  late TextEditingController _anoFinalController;
  late TextEditingController _valorMinController;
  late TextEditingController _valorMaxController;
  int? _modeloSelecionadoId;
  Future<void>? _loadData;

  late BuscaViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _anoInicialController = TextEditingController();
    _anoFinalController = TextEditingController();
    _valorMinController = TextEditingController();
    _valorMaxController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = Provider.of<BuscaViewModel>(context, listen: false);
    _loadData = _viewModel.conectar();
  }

  @override
  void dispose() {
    _anoInicialController.dispose();
    _anoFinalController.dispose();
    _valorMinController.dispose();
    _valorMaxController.dispose();
    super.dispose();
  }

  Widget _buildFormulario(BuscaViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            value: _modeloSelecionadoId,
            decoration: const InputDecoration(
              labelText: 'Modelo (Opcional)',
              border: OutlineInputBorder(),
            ),
            items: List.generate(
              viewModel.numModelos,
                  (index) {
                Modelo modelo = viewModel.getModeloAt(index);
                return DropdownMenuItem(
                  value: modelo.id,
                  child: Text(modelo.nome),
                );
              },
            ),
            onChanged: (value) {
              setState(() {
                _modeloSelecionadoId = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _anoInicialController,
                  decoration: const InputDecoration(
                    labelText: 'Ano Inicial',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _anoFinalController,
                  decoration: const InputDecoration(
                    labelText: 'Ano Final',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _valorMinController,
                  decoration: const InputDecoration(
                    labelText: 'Valor Min (R\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _valorMaxController,
                  decoration: const InputDecoration(
                    labelText: 'Valor Max (R\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.search),
            label: const Text('Buscar'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              viewModel.buscarAnuncios(
                modeloId: _modeloSelecionadoId,
                anoInicial: _anoInicialController.text,
                anoFinal: _anoFinalController.text,
                valorMin: _valorMinController.text,
                valorMax: _valorMaxController.text,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultados(BuscaViewModel viewModel) {
    if (viewModel.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.resultados.isEmpty) {
      return const Center(child: Text('Nenhum resultado encontrado.'));
    }

    return ListView.builder(
      itemCount: viewModel.resultados.length,
      itemBuilder: (context, index) {
        Anuncio anuncio = viewModel.resultados[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            title: Text(anuncio.descricao),
            subtitle: Text(
              'Modelo: ${anuncio.modelo?.nome ?? 'N/A'} - Cidade: ${anuncio.cidade?.nome ?? 'N/A'}',
            ),
            trailing: Text(
              'R\$ ${anuncio.valor.toStringAsFixed(2)}\nAno: ${anuncio.ano}',
              textAlign: TextAlign.right,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Anúncios'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return Consumer<BuscaViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  children: [
                    _buildFormulario(viewModel),
                    const Divider(height: 20, thickness: 2),
                    Expanded(
                      child: _buildResultados(viewModel),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile2prova3/ui/viewmodels/BuscaViewModel.dart';
import 'package:mobile2prova3/ui/viewmodels/AnuncioViewModel.dart';
import 'package:mobile2prova3/ui/viewmodels/CidadeViewModel.dart';
import 'package:mobile2prova3/ui/viewmodels/ModeloViewModel.dart';
import 'package:mobile2prova3/ui/viewmodels/MarcaViewModel.dart';
import 'package:mobile2prova3/ui/views/TelaInicial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MarcaViewModel()),
          ChangeNotifierProvider(create: (_) => CidadeViewModel()),
          ChangeNotifierProvider(create: (_) => ModeloViewModel()),
          ChangeNotifierProvider(create: (_) => AnuncioViewModel()),
          ChangeNotifierProvider(create: (_) => BuscaViewModel())
        ],
        child: MaterialApp(
            home: const TelaInicial(),
            debugShowCheckedModeBanner: false
        )
    );
  }
}
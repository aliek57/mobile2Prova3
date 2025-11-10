import 'package:flutter/material.dart';
import 'package:mobile2prova3/ui/views/TelaMarca.dart';
import 'package:mobile2prova3/ui/views/TelaCidade.dart';
import 'package:mobile2prova3/ui/views/TelaModelo.dart';
import 'package:mobile2prova3/ui/views/TelaAnuncio.dart';
import 'package:mobile2prova3/ui/views/TelaBusca.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Veículos'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMenuItem(
              context,
              icon: Icons.directions_car,
              label: 'Gerenciar Marcas',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TelaMarca()));
              },
            ),
            const Divider(),
            _buildMenuItem(
              context,
              icon: Icons.location_city,
              label: 'Gerenciar Cidades',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TelaCidade()));
              },
            ),
            const Divider(),
            _buildMenuItem(
              context,
              icon: Icons.category,
              label: 'Gerenciar Modelos',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TelaModelo()));
              },
            ),
            const Divider(),
            _buildMenuItem(
              context,
              icon: Icons.price_change,
              label: 'Gerenciar Anúncios',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TelaAnuncio()));
              },
            ),
            const Divider(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Buscar Anúncios'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TelaBusca()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, size: 32, color: Colors.blue[700]),
      title: Text(label, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
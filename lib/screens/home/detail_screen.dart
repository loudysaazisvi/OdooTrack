import 'package:flutter/material.dart';
import '../../models/kendaraan_model.dart';
import '../../routes/app_routes.dart';

class DetailScreen extends StatefulWidget {
  final Kendaraan kendaraan;

  const DetailScreen({super.key, required this.kendaraan});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _catatan;

  Future<void> _bukaFormCatatan() async {
    final hasil = await Navigator.pushNamed<String>(
      context,
      AppRoutes.catatanForm,
    );
    if (!mounted || hasil == null) return;

    setState(() => _catatan = hasil);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.kendaraan;

    return Scaffold(
      appBar: AppBar(title: Text(item.displayName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(item.displayName, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Tahun: ${item.tahun}'),
          const SizedBox(height: 16),
          Text('Odometer: ${item.odometer} km'),
          const Divider(height: 32),
          Text(
            _catatan == null ? 'Belum ada catatan.' : 'Catatan: $_catatan',
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _bukaFormCatatan,
            icon: const Icon(Icons.edit_note),
            label: const Text('Tulis Catatan'),
          ),
        ],
      ),
    );
  }
}

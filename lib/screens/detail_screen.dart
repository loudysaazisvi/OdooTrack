import 'package:flutter/material.dart';
import '../models/kendaraan.dart';
import '../routes/app_routes.dart';

class DetailScreen extends StatefulWidget {
  final Kendaraan item;

  const DetailScreen({super.key, required this.item});

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
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.tipe),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(item.tipe, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(item.nomorPolisi),
          const SizedBox(height: 16),
          Text('Odometer: ${item.odometerTerkini} km'),
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

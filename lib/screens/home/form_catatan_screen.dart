// lib/screens/home/form_catatan_screen.dart
// Langkah H: Form Catatan Servis (StatefulWidget, Form, Controllers, Validators, PopScope, Navigator.pop dengan hasil)

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/kendaraan_model.dart';
import '../../models/catatan_servis_model.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class FormCatatanScreen extends StatefulWidget {
  final Kendaraan kendaraan; // Langkah H: Menerima data kendaraan yang akan dicatat

  const FormCatatanScreen({
    super.key,
    required this.kendaraan,
  });

  @override
  State<FormCatatanScreen> createState() => _FormCatatanScreenState();
}

class _FormCatatanScreenState extends State<FormCatatanScreen> {
  // Poin 1: Form & GlobalKey<FormState>
  final _formKey = GlobalKey<FormState>();

  // Poin 2: Input teks menggunakan TextEditingController
  final _judulController = TextEditingController();
  final _biayaController = TextEditingController();
  final _kmController = TextEditingController();

  // Poin 2: Membuang semua controller di dispose()
  @override
  void dispose() {
    _judulController.dispose();
    _biayaController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  // Poin 8: Mengembalikan data memakai Navigator.pop(context, hasil)
  void _simpan() {
    // Poin 1: Validasi form menggunakan FormState
    if (!_formKey.currentState!.validate()) return;

    final catatan = CatatanServis(
      judul: _judulController.text.trim(),
      biaya: int.parse(_biayaController.text.trim()),
      km: int.parse(_kmController.text.trim()),
    );

    // Poin 8: Navigator.pop mengembalikan objek CatatanServis
    Navigator.pop(context, catatan);
  }

  @override
  Widget build(BuildContext context) {
    // Poin 9: Gunakan PopScope dan onPopInvokedWithResult (bukan WillPopScope)
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Tambah Catatan Servis'),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textDark,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          // Poin 1: Menggunakan Form widget
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Motor: ${widget.kendaraan.displayName}',
                  style: AppTextStyles.bodyLight,
                ),
                const SizedBox(height: 20),
                // Poin 1: Validasi field menggunakan Validators.required
                CustomTextField(
                  label: 'Judul Servis',
                  hintText: 'Contoh: Ganti Oli Mesin',
                  controller: _judulController,
                  validator: (v) => Validators.required(v, 'Judul servis'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Biaya (Rp)',
                  hintText: 'Contoh: 150000',
                  controller: _biayaController,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final req = Validators.required(v, 'Biaya');
                    if (req != null) return req;
                    if (int.tryParse(v!.trim()) == null) {
                      return 'Biaya harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Odometer (km)',
                  hintText: 'Contoh: 13000',
                  controller: _kmController,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final req = Validators.required(v, 'Odometer');
                    if (req != null) return req;
                    if (int.tryParse(v!.trim()) == null) {
                      return 'Odometer harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Simpan Catatan',
                  onPressed: _simpan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/screens/home/detail_kendaraan_screen.dart
// Langkah G & H: Halaman Detail Kendaraan (menerima Kendaraan, membuka Form Catatan & menerima CatatanServis)

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/kendaraan_model.dart';
import '../../models/catatan_servis_model.dart';
import '../../routes/app_routes.dart';

class DetailKendaraanScreen extends StatefulWidget {
  final Kendaraan kendaraan; // Langkah G: Menerima data kendaraan lewat arguments

  const DetailKendaraanScreen({
    super.key,
    required this.kendaraan,
  });

  @override
  State<DetailKendaraanScreen> createState() => _DetailKendaraanScreenState();
}

class _DetailKendaraanScreenState extends State<DetailKendaraanScreen> {
  // Poin 8: Menyimpan daftar catatan servis yang dikembalikan dari FormCatatanScreen
  final List<CatatanServis> _daftarCatatan = [];

  // Poin 4, 7, 8: Mengirim data ke FormCatatan dan menerima data kembalian
  Future<void> _tambahCatatan() async {
    // Poin 7: Mengirim arguments bertipe Kendaraan
    // Poin 8: Menerima data kembalian bertipe CatatanServis dari FormCatatanScreen
    final hasil = await Navigator.pushNamed<CatatanServis>(
      context,
      AppRoutes.formCatatan,
      arguments: widget.kendaraan,
    );

    // Poin 4: Check if (!mounted) return sesudah await
    if (!mounted) return;

    if (hasil != null) {
      setState(() {
        _daftarCatatan.add(hasil);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" berhasil ditambahkan!')),
      );
    }
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
          title: const Text('Detail Kendaraan'),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textDark,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Informasi Kendaraan (Sesuai action-detail-overlay)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Detail Kendaraan', style: AppTextStyles.heading3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Aktif',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildRow('Nama Kendaraan', widget.kendaraan.displayName),
                    const SizedBox(height: 12),
                    _buildRow('Nomor Polisi', widget.kendaraan.nopol),
                    const SizedBox(height: 12),
                    _buildRow('Odometer', '${widget.kendaraan.odometer} km'),
                    const SizedBox(height: 12),
                    _buildRow('Terakhir Servis', '12 Agu 2026'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section Catatan Servis (Langkah H)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Catatan Servis', style: AppTextStyles.heading3),
                  ElevatedButton.icon(
                    onPressed: _tambahCatatan,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Tambah Catatan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // List Catatan Servis Baru yang Ditambahkan
              if (_daftarCatatan.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Belum ada catatan servis baru',
                      style: AppTextStyles.bodyLight,
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _daftarCatatan.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _daftarCatatan[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.build, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.judul, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                                Text('Odometer: ${item.km} km', style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          Text(
                            'Rp ${item.biaya}',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.statusNormal,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyLight),
        Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

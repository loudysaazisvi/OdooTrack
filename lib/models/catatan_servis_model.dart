// lib/models/catatan_servis_model.dart
// Langkah B: Model data catatan servis untuk Langkah H (Form Catatan)

class CatatanServis {
  final String judul;
  final int biaya;
  final int km;

  CatatanServis({
    required this.judul,
    required this.biaya,
    required this.km,
  });

  @override
  String toString() => '$judul — Rp $biaya (di $km km)';
}

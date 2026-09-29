// lib/models/kendaraan_model.dart
// Langkah B: Model kendaraan (ditambah field nopol untuk Detail screen)

class Kendaraan {
  final String id;
  final String nama; // e.g. "Honda Scoopy"
  final int tahun;
  final String nopol; // Langkah B: ditambahkan untuk Detail
  int odometer;

  Kendaraan({
    required this.id,
    required this.nama,
    required this.tahun,
    required this.nopol,
    required this.odometer,
  });

  String get displayName => '$nama $tahun';
}

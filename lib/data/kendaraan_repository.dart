// lib/data/kendaraan_repository.dart
// Langkah B: Repository data dummy (Singleton, tanpa Provider)

import '../models/kendaraan_model.dart';

class KendaraanRepository {
  // Singleton agar data konsisten di seluruh screen
  static final KendaraanRepository _instance = KendaraanRepository._internal();
  factory KendaraanRepository() => _instance;
  KendaraanRepository._internal();

  // Data dummy kendaraan
  final List<Kendaraan> _daftarKendaraan = [
    Kendaraan(id: '1', nama: 'Honda Scoopy', tahun: 2021, nopol: 'BA 4321 KZ', odometer: 12450),
    Kendaraan(id: '2', nama: 'Yamaha NMAX', tahun: 2022, nopol: 'B 4931 SWK', odometer: 5200),
  ];

  String _activeId = '1';

  List<Kendaraan> get daftarKendaraan => List.unmodifiable(_daftarKendaraan);

  Kendaraan? get aktifKendaraan {
    try {
      return _daftarKendaraan.firstWhere((k) => k.id == _activeId);
    } catch (_) {
      return _daftarKendaraan.isNotEmpty ? _daftarKendaraan.first : null;
    }
  }

  void setActiveKendaraan(String id) {
    _activeId = id;
  }

  void updateOdometer(String id, int newOdo) {
    final idx = _daftarKendaraan.indexWhere((k) => k.id == id);
    if (idx != -1) _daftarKendaraan[idx].odometer = newOdo;
  }

  // Simulasi fetch dari server (untuk demo loading/error)
  Future<List<Kendaraan>> fetchKendaraan() async {
    await Future.delayed(const Duration(seconds: 1));
    return daftarKendaraan;
  }
}

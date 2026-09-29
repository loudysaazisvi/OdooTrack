import 'package:flutter/material.dart';

import '../models/kendaraan_model.dart';

class KendaraanProvider extends ChangeNotifier {
  // Daftar kendaraan yang dimiliki user
  final List<Kendaraan> _daftarKendaraan = [
    Kendaraan(id: '1', nama: 'Honda Beat', tahun: 2021, nopol: 'BA 4321 KZ', odometer: 14850),
    Kendaraan(id: '2', nama: 'Yamaha NMAX', tahun: 2022, nopol: 'B 4931 SWK', odometer: 5200),
  ];

  // ID kendaraan yang sedang dipilih (aktif) di dashboard
  String? _activeKendaraanId = '1';

  List<Kendaraan> get daftarKendaraan => _daftarKendaraan;

  Kendaraan? get aktifKendaraan {
    try {
      return _daftarKendaraan.firstWhere((k) => k.id == _activeKendaraanId);
    } catch (e) {
      return _daftarKendaraan.isNotEmpty ? _daftarKendaraan.first : null;
    }
  }

  // Mock data for Dashboard stats
  int get totalDistance {
    return _daftarKendaraan.fold(0, (sum, item) => sum + item.odometer);
  }
  int get averagePerDay => 42;
  int get serviceCount => 12;
  String get totalCost => 'Rp 1,4 Jt';

  void updateOdometer(int newOdo) {
    var k = aktifKendaraan;
    if (k != null) {
      k.odometer = newOdo;
      notifyListeners();
    }
  }

  void setActiveKendaraan(String id) {
    _activeKendaraanId = id;
    notifyListeners();
  }

  void tambahKendaraan(Kendaraan k) {
    _daftarKendaraan.add(k);
    _activeKendaraanId ??= k.id;
    notifyListeners();
  }
}

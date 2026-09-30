import '../models/kendaraan.dart';

class KendaraanRepository {
  static const List<Kendaraan> _items = [
    Kendaraan(
      id: '1',
      merk: 'Honda',
      tipe: 'Scoopy',
      tahun: '2022',
      nomorPolisi: 'BA 4321 KZ',
      odometerTerkini: 12450,
    ),
    Kendaraan(
      id: '2',
      merk: 'Yamaha',
      tipe: 'NMAX',
      tahun: '2021',
      nomorPolisi: 'B 4931 SWK',
      odometerTerkini: 15000,
    ),
  ];

  Future<List<Kendaraan>> fetchItems({bool simulateError = false}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (simulateError) {
      throw Exception('Gagal memuat data. Periksa koneksi internet.');
    }
    return _items;
  }
}

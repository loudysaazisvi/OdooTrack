import '../models/kendaraan_model.dart';

class KendaraanRepository {
  static final List<Kendaraan> _items = [
    Kendaraan(id: '1', nama: 'Honda Scoopy', tahun: 2021, odometer: 12450),
    Kendaraan(id: '2', nama: 'Yamaha NMAX', tahun: 2022, odometer: 5200),
  ];

  Future<List<Kendaraan>> fetchItems({bool simulateError = false}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (simulateError) {
      throw Exception('Gagal memuat data. Periksa koneksi internet.');
    }
    return _items;
  }
}

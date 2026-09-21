class Kendaraan {
  final String id;
  final String nama; // e.g. "Honda Beat"
  final int tahun;
  int odometer;

  Kendaraan({
    required this.id,
    required this.nama,
    required this.tahun,
    required this.odometer,
  });

  String get displayName => '$nama $tahun';
}

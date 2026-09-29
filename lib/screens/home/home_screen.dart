// lib/screens/home/home_screen.dart
// Langkah E & G: Status tampilan (loading, error + retry, data), PopScope, named route ke Detail

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../data/kendaraan_repository.dart';
import '../../models/kendaraan_model.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  final String nickname; // Langkah F: menerima parameter nickname

  const HomeScreen({
    super.key,
    required this.nickname,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Poin 5: Status tampilan (loading, error, data)
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';
  List<Kendaraan> _daftarKendaraan = [];

  final KendaraanRepository _repository = KendaraanRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Poin 3, 4, 5: Fetch data asinkron dengan try/catch/finally & retry
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _isError = false;
      _errorMessage = '';
    });

    try {
      // Poin 3: Simulasi proses async
      final data = await _repository.fetchKendaraan();

      // Poin 4: Check if (!mounted) return sesudah await
      if (!mounted) return;

      setState(() {
        _daftarKendaraan = data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isError = true;
        _errorMessage = 'Gagal memuat data kendaraan: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Poin 9: Gunakan PopScope dan onPopInvokedWithResult (bukan WillPopScope)
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: _buildBody(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Iconsax.receipt_2_1), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.motorcycle), label: 'Motor'),
            BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  // Poin 5: Penanganan berbagai kondisi status tampilan
  Widget _buildBody() {
    // 1. Kondisi Loading
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat data kendaraan...'),
          ],
        ),
      );
    }

    // 2. Kondisi Error (menyediakan tombol muat ulang / retry)
    if (_isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.statusDanger),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Muat Ulang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Kondisi Data Kosong
    if (_daftarKendaraan.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.motorcycle_outlined, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text('Belum ada data kendaraan', style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text('Tambahkan kendaraan pertama Anda', style: AppTextStyles.bodyLight),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Cek Lagi'),
            ),
          ],
        ),
      );
    }

    // 4. Kondisi Data Tampil Normal
    final aktif = _repository.aktifKendaraan ?? _daftarKendaraan.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildOdometerCard(aktif),
          const SizedBox(height: 24),
          _buildQuickActions(aktif),
          const SizedBox(height: 24),
          _buildPromoBanner(),
          const SizedBox(height: 24),
          _buildSectionHeader('Jadwal Servis', 'Lihat Semua'),
          const SizedBox(height: 12),
          _buildServiceScheduleList(),
          const SizedBox(height: 24),
          _buildSectionHeader('Riwayat Terakhir', 'Lihat Semua'),
          const SizedBox(height: 12),
          _buildHistoryList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Iconsax.location_tick, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'OdoTrack',
              style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Iconsax.setting_2, color: AppColors.textDark),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _buildOdometerCard(Kendaraan aktif) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Senin, 21 September 2026', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
          const SizedBox(height: 8),
          Text('Hi, ${widget.nickname}! 👋', style: AppTextStyles.heading2.copyWith(color: Colors.white)),
          Text('Yuk cek kondisi motormu hari ini.', style: AppTextStyles.caption.copyWith(color: Colors.white)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ODOMETER AKTIF', style: AppTextStyles.caption.copyWith(color: Colors.white70, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${aktif.odometer}', style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 32)),
                      const SizedBox(width: 4),
                      Text('km', style: AppTextStyles.body.copyWith(color: Colors.white70)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _tampilkanPilihMotor(context),
                    child: Row(
                      children: [
                        Text(
                          aktif.displayName,
                          style: AppTextStyles.caption.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _tampilkanPilihMotor(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.motorcycle, color: Colors.white, size: 32),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _tampilkanPilihMotor(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Kendaraan', style: AppTextStyles.heading2),
              const SizedBox(height: 16),
              ..._daftarKendaraan.map((k) {
                bool isSelected = k.id == _repository.aktifKendaraan?.id;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.motorcycle, color: isSelected ? AppColors.primary : Colors.grey),
                  ),
                  title: Text(k.displayName, style: AppTextStyles.body.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  subtitle: Text('${k.odometer} km'),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                  onTap: () {
                    setState(() {
                      _repository.setActiveKendaraan(k.id);
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(Kendaraan aktif) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aksi Cepat', style: AppTextStyles.heading3),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Poin 6 & 7: Named route ke Detail Kendaraan membawa objek Kendaraan
            GestureDetector(
              onTap: () async {
                final updated = await Navigator.pushNamed(
                  context,
                  AppRoutes.detailKendaraan,
                  arguments: aktif,
                );
                if (updated != null && mounted) {
                  setState(() {});
                }
              },
              child: _buildActionCard(
                icon: Icons.motorcycle,
                label: 'Detail\nKendaraan',
                bgColor: const Color(0xFFE0E0FF),
                iconColor: AppColors.primary,
              ),
            ),
            _buildActionCard(
              icon: Icons.build_outlined,
              label: 'Servis',
              bgColor: const Color(0xFFE8F5E9),
              iconColor: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 36),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: Colors.blue, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Gratis Cek Rem!', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('PROMO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text('Setiap servis oli di bulan September. Berlaku s/d 30 Sep.', style: AppTextStyles.caption.copyWith(fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading3),
        if (action.isNotEmpty)
          Text(action, style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildServiceScheduleList() {
    return Column(
      children: [
        _buildScheduleItem(
          icon: Iconsax.setting_4,
          title: 'Servis Berkala',
          subtitle: 'Dalam 2.550 km',
          statusColor: AppColors.primary,
        ),
        const SizedBox(height: 12),
        _buildScheduleItem(
          icon: Iconsax.document,
          title: 'Pajak Kendaraan',
          subtitle: '12 Nov 2026',
          statusColor: Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildScheduleItem(
          icon: Icons.water_drop_outlined,
          title: 'Ganti Oli',
          subtitle: 'Dalam 550 km',
          statusColor: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildScheduleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color statusColor,
  }) {
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children: [
        _buildHistoryItem('Servis Ringan', '12 Agu 2026', 'Rp250.000'),
        const SizedBox(height: 12),
        _buildHistoryItem('Ganti Oli + Filter', '15 Mei 2026', 'Rp180.000'),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String date, String price) {
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
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.receipt_2_1, color: AppColors.textLight, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Text(date, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(price, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.statusNormal)),
        ],
      ),
    );
  }
}

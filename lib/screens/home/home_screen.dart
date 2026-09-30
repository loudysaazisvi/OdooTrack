import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/kendaraan_provider.dart';
import '../../models/kendaraan_model.dart' as old_model;
import '../../data/kendaraan_repository.dart';
import '../../models/kendaraan.dart';
import '../../widgets/state_views.dart';
import '../../routes/app_routes.dart';

enum ViewStatus { loading, success, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final _repository = KendaraanRepository();
  ViewStatus _status = ViewStatus.loading;
  List<Kendaraan> _items = [];
  String _errorMessage = '';
  bool _simulateError = false; 

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    if (_status != ViewStatus.loading) {
      setState(() => _status = ViewStatus.loading);
    }
    try {
      final items = await _repository.fetchItems(simulateError: _simulateError);
      if (!mounted) return;
      setState(() {
        _items = items;
        _status = ViewStatus.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _status = ViewStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildContent(),
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
    );
  }

  Widget _buildContent() {
    return switch (_status) {
      ViewStatus.loading => const LoadingView(),
      ViewStatus.error => ErrorView(message: _errorMessage, onRetry: _loadItems),
      ViewStatus.success => _buildList(),
    };
  }

  Widget _buildList() {
    if (_items.isEmpty) {
      return const EmptyView(message: 'Belum ada kendaraan.');
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildOdometerCard(),
          const SizedBox(height: 24),
          _buildQuickActions(),
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
          _buildSectionHeader('Statistik Odo', ''),
          const SizedBox(height: 12),
          _buildStatsGrid(),
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

  Widget _buildOdometerCard() {
    return GestureDetector(
      onTap: () {
        if (_items.isNotEmpty) {
          Navigator.pushNamed(context, AppRoutes.detail, arguments: _items.first);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(76),
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
          Text('Hi, ${context.watch<AuthProvider>().nickname}! 👋', style: AppTextStyles.heading2.copyWith(color: Colors.white)),
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
                      Text('${_items.isNotEmpty ? _items.first.odometerTerkini : 0}', style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 32)),
                      const SizedBox(width: 4),
                      Text('km', style: AppTextStyles.body.copyWith(color: Colors.white70)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _tampilkanPilihMotor(context),
                    child: Row(
                      children: [
                        Text(
                          _items.isNotEmpty ? _items.first.tipe : 'Pilih Motor',
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
                    color: Colors.white.withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.motorcycle, color: Colors.white, size: 32),
                ),
              ),
            ],
          )
        ],
      ),
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
        final kendaraanProvider = context.read<KendaraanProvider>();
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Kendaraan', style: AppTextStyles.heading2),
              const SizedBox(height: 16),
              ...kendaraanProvider.daftarKendaraan.map((k) {
                bool isSelected = k.id == kendaraanProvider.aktifKendaraan?.id;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withAlpha(25) : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.motorcycle, color: isSelected ? AppColors.primary : Colors.grey),
                  ),
                  title: Text(k.displayName, style: AppTextStyles.body.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  subtitle: Text('${k.odometer} km', style: AppTextStyles.caption),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                  onTap: () {
                    kendaraanProvider.setActiveKendaraan(k.id);
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

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aksi Cepat', style: AppTextStyles.heading3),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionItem(Iconsax.setting_4, 'Servis\nRutin', const Color(0xFFE3F2FD), Colors.blue, () {
              Navigator.pushNamed(context, AppRoutes.detail, arguments: _items.first);
            }),
            _buildActionItem(Icons.water_drop_outlined, 'Ganti\nOli', const Color(0xFFFFF3E0), Colors.orange, () {
              Navigator.pushNamed(context, AppRoutes.detail, arguments: _items.first);
            }),
            _buildActionItem(Icons.edit, 'Tambah\nCatatan', const Color(0xFFFFF8E1), Colors.amber, () async {
              final hasil = await Navigator.pushNamed<String>(context, AppRoutes.catatanForm);
              if (hasil != null && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Catatan tersimpan: $hasil')));
              }
            }),
            _buildActionItem(Iconsax.receipt_2_1, 'Riwayat', const Color(0xFFF3E5F5), Colors.purple, () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur Riwayat belum tersedia')));
            }),
          ],
        )
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color bgColor, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500),
        )
      ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light blue
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
          title: 'Tune-Up Berkala',
          subtitle: 'Honda Beat 2021',
          statusText: 'Segera',
          statusColor: AppColors.statusWarning,
          dueDate: '3 hari lagi',
          distance: '14.950 km',
        ),
        const SizedBox(height: 12),
        _buildScheduleItem(
          icon: Icons.warning_amber_rounded,
          title: 'Ganti Oli Mesin',
          subtitle: 'Yamaha NMAX 2022',
          statusText: 'Terlambat',
          statusColor: AppColors.statusDanger,
          dueDate: 'Terlambat 3 hari',
          distance: '15.200 km',
        ),
        const SizedBox(height: 12),
        _buildScheduleItem(
          icon: Icons.check_circle_outline,
          title: 'Cek Rem & Kampas',
          subtitle: 'Honda PCX 160',
          statusText: 'Normal',
          statusColor: AppColors.statusNormal,
          dueDate: '2 minggu lagi',
          distance: '18.000 km',
        ),
      ],
    );
  }

  Widget _buildScheduleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String statusText,
    required Color statusColor,
    required String dueDate,
    required String distance,
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
              color: statusColor.withAlpha(25),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, color: statusColor, size: 8),
                    const SizedBox(width: 4),
                    Text(dueDate, style: AppTextStyles.caption.copyWith(color: statusColor)),
                  ],
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(statusText, style: AppTextStyles.caption.copyWith(color: statusColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(distance, style: AppTextStyles.caption),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children: [
        _buildHistoryItem('Servis CVT', '1 Agu 2026 • 13.500 km', 'Rp 150.000'),
        const SizedBox(height: 12),
        _buildHistoryItem('Ganti Ban Belakang', '15 Jul 2026 • 11.000 km', 'Rp 220.000'),
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
          Text(price, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: [
        _buildStatCard(Icons.speed, '14.850 km', 'Total Jarak', const Color(0xFFE8EAF6)),
        _buildStatCard(Icons.analytics, '42 km', 'Rata-rata/ hari', const Color(0xFFFFF3E0)),
        _buildStatCard(Icons.build, '12x', 'Servis Dilakukan', const Color(0xFFE0F2F1)),
        _buildStatCard(Icons.attach_money, 'Rp 1,4 Jt', 'Total Biaya', const Color(0xFFFBE9E7)),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.textLight, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

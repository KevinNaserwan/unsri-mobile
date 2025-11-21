import 'package:flutter/material.dart';

import '../models/app_role.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/app_bottom_nav.dart';
import 'mahasiswa_screen.dart';
import 'perkuliahan_screen.dart';

class BroadcastScreen extends StatefulWidget {
  final UserProfile profile;

  const BroadcastScreen({super.key, required this.profile});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_BroadcastItem> _generalBroadcasts = const [
    _BroadcastItem(
      title: 'Kuliah Umum AI & Big Data',
      description:
          'Kami mengundang seluruh mahasiswa Fasilkom untuk menghadiri kuliah umum bersama Prof. Dr. Budi Santoso pada 10 Sept 2025 di Aula Utama.',
      author: 'Dekan II Fasilkom',
      timestamp: '1 Sept 2025, 09:15 WIB',
      avatarLabel: 'D',
      avatarColor: Color(0xFFFFE28D),
    ),
    _BroadcastItem(
      title: 'Pemeliharaan Sistem SIMAK',
      description:
          'Akses SIMAK akan mengalami gangguan sementara pada 2 Sept 2025 pukul 00:00–04:00 WIB untuk pemeliharaan server.',
      author: 'Admin | Mba Renny',
      timestamp: '1 Sept 2025, 08:30 WIB',
      avatarLabel: 'A',
      avatarColor: Color(0xFFB5F5E6),
    ),
    _BroadcastItem(
      title: 'Pendaftaran Beasiswa UNSRI 2025',
      description:
          'Beasiswa UNSRI Gelombang 2 telah dibuka. Pendaftaran dibuka hingga 15 Sept 2025 melalui laman resmi UNSRI.',
      author: 'Admin | Mba Renny',
      timestamp: '1 Sept 2025, 07:30 WIB',
      avatarLabel: 'A',
      avatarColor: Color(0xFFB5F5E6),
    ),
  ];

  final List<_BroadcastItem> _classUpdates = const [
    _BroadcastItem(
      title: 'Perubahan Jadwal Mata Kuliah',
      description:
          'Kelas “Pemrograman Web” hari Rabu dipindahkan ke ruang 3.04 mulai minggu depan.',
      author: 'Dosen Pengampu',
      timestamp: '31 Agt 2025, 19:00 WIB',
      avatarLabel: 'DW',
      avatarColor: Color(0xFFE8EBF3),
    ),
    _BroadcastItem(
      title: 'Pengumpulan Tugas Besar',
      description:
          'Pastikan laporan akhir sudah diunggah di LMS paling lambat 5 Sept 2025 pukul 23:59 WIB.',
      author: 'Koordinator Kelas',
      timestamp: '31 Agt 2025, 17:45 WIB',
      avatarLabel: 'KK',
      avatarColor: Color(0xFFFFE28D),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);
    final maxContentWidth = isDesktop
        ? 640.0
        : isTablet
        ? 560.0
        : double.infinity;

    final bodyContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        SizedBox(height: Responsive.spacing(context, 16)),
        _buildSearchField(context),
        SizedBox(height: Responsive.spacing(context, 24)),
        ..._buildGeneralBroadcasts(context),
        Text(
          'Kelas Saya',
          style: TextStyle(
            fontFamily: 'SFProDisplay',
            fontWeight: FontWeight.w600,
            fontSize: Responsive.fontSize(context, 18),
            height: 1.4,
            letterSpacing: 0.5,
            color: AppColors.text500,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, 18)),
        ..._buildClassUpdates(context),
      ],
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPad,
              Responsive.spacing(context, 24),
              horizontalPad,
              Responsive.spacing(context, 24),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: maxContentWidth.isFinite
                  ? ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: bodyContent,
                    )
                  : bodyContent,
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNav(
          selectedTab: AppTab.broadcast,
          role: widget.profile.role,
          onTabSelected: _handleBottomNavTap,
        ),
        floatingActionButton: widget.profile.role == AppRole.mahasiswa
            ? null
            : _buildFab(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Broadcast UNSRI',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.fontSize(context, 26),
                  height: 1.4,
                  letterSpacing: 0.5,
                  color: AppColors.text500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildGeneralBroadcasts(BuildContext context) {
    final items = _filterItems(_generalBroadcasts);
    return List.generate(items.length, (index) {
      final isLast = index == items.length - 1;
      return Padding(
        padding: EdgeInsets.only(
          bottom: isLast
              ? Responsive.spacing(context, 24)
              : Responsive.spacing(context, 12),
        ),
        child: _BroadcastCard(item: items[index]),
      );
    });
  }

  List<Widget> _buildClassUpdates(BuildContext context) {
    final items = _filterItems(_classUpdates);
    return List.generate(items.length, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: Responsive.spacing(context, 12)),
        child: _BroadcastCard(item: items[index], isCompact: true),
      );
    });
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, 16),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 12),
        ),
        border: Border.all(color: const Color(0xFFE4E6EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _query = value.trim());
              },
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontSize: Responsive.fontSize(context, 15),
                color: AppColors.text500,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: Responsive.spacing(context, 12),
                ),
                hintText: 'Cari Informasi',
                hintStyle: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontSize: Responsive.fontSize(context, 15),
                  color: AppColors.text300,
                ),
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: Responsive.spacing(context, 4)),
          Image.asset(
            'assets/icons/search-status.png',
            width: Responsive.spacing(context, 24),
            height: Responsive.spacing(context, 24),
            color: AppColors.text400,
          ),
        ],
      ),
    );
  }

  List<_BroadcastItem> _filterItems(List<_BroadcastItem> items) {
    if (_query.isEmpty) return items;
    final lower = _query.toLowerCase();
    return items
        .where(
          (item) =>
              item.title.toLowerCase().contains(lower) ||
              item.description.toLowerCase().contains(lower) ||
              item.author.toLowerCase().contains(lower),
        )
        .toList();
  }

  void _handleBottomNavTap(AppTab tab) {
    if (tab == AppTab.broadcast) return;

    final navigator = Navigator.of(context);

    if (tab == AppTab.beranda) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }

    Widget? target;
    if (tab == AppTab.perkuliahan) {
      target = PerkuliahanScreen(profile: widget.profile);
    } else if (tab == AppTab.mahasiswa) {
      target = MahasiswaScreen(profile: widget.profile);
    }

    if (target != null) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => target!),
        (route) => route.isFirst,
      );
    }
  }

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCreateBroadcastModal(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, 18),
          vertical: Responsive.spacing(context, 12),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary500,
          borderRadius: BorderRadius.circular(
            Responsive.borderRadius(context, 999),
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: AppColors.primary500.withValues(alpha: 0.25),
          //     blurRadius: 16,
          //     offset: const Offset(0, 10),
          //   ),
          // ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
              size: Responsive.iconSize(context, 20),
            ),
            SizedBox(width: Responsive.spacing(context, 8)),
            Text(
              'Tambah Broadcast',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w600,
                fontSize: Responsive.fontSize(context, 14),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateBroadcastModal(BuildContext parentContext) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? type;
    String? audience;

    await showDialog(
      context: parentContext,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (modalContext, setState) {
            final bottomInset = MediaQuery.of(modalContext).viewInsets.bottom;
            return AnimatedPadding(
              padding: EdgeInsets.only(bottom: bottomInset),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.spacing(
                      context,
                      Responsive.isTablet(context) ? 40 : 20,
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.isTablet(context) ? 520 : 560,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFF),
                          borderRadius: BorderRadius.circular(
                            Responsive.borderRadius(context, 12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 30,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Responsive.borderRadius(context, 24),
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              Responsive.horizontalPadding(modalContext),
                              Responsive.spacing(modalContext, 24),
                              Responsive.horizontalPadding(modalContext),
                              Responsive.spacing(modalContext, 28),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Broadcast UNSRI',
                                      style: TextStyle(
                                        fontFamily: 'SFProDisplay',
                                        fontWeight: FontWeight.w600,
                                        fontSize: Responsive.fontSize(
                                          context,
                                          22,
                                        ),
                                        color: AppColors.text500,
                                      ),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(24),
                                      onTap: () =>
                                          Navigator.of(modalContext).pop(),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          Responsive.spacing(modalContext, 4),
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close_rounded),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Responsive.spacing(modalContext, 16),
                                ),
                                _BroadcastTextField(
                                  label: 'Judul Broadcast',
                                  controller: titleController,
                                  hintText: 'Masukkan judul',
                                ),
                                SizedBox(
                                  height: Responsive.spacing(context, 12),
                                ),
                                _BroadcastTextField(
                                  label: 'Deskripsi',
                                  controller: descriptionController,
                                  hintText: 'Masukkan deskripsi',
                                  maxLines: 4,
                                ),
                                SizedBox(
                                  height: Responsive.spacing(modalContext, 12),
                                ),
                                _BroadcastSelectField(
                                  label: 'Tipe',
                                  value: type ?? 'Pilih jenis broadcast',
                                  onTap: () async {
                                    final selected = await _showOptionPicker(
                                      modalContext,
                                      title: 'Pilih jenis broadcast',
                                      options: const [
                                        'Pengumuman Umum',
                                        'Kegiatan Akademik',
                                        'Informasi Sistem',
                                      ],
                                    );
                                    if (selected != null) {
                                      setState(() => type = selected);
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: Responsive.spacing(modalContext, 12),
                                ),
                                _BroadcastSelectField(
                                  label: 'Tujuan',
                                  value: audience ?? 'Pilih audiens broadcast',
                                  onTap: () async {
                                    final selected = await _showOptionPicker(
                                      modalContext,
                                      title: 'Pilih audiens broadcast',
                                      options: const [
                                        'Seluruh Mahasiswa',
                                        'Mahasiswa Prodi',
                                        'Dosen',
                                        'Admin',
                                      ],
                                    );
                                    if (selected != null) {
                                      setState(() => audience = selected);
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: Responsive.spacing(modalContext, 18),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          final schedule =
                                              await _pickScheduleDateTime(
                                                modalContext,
                                              );
                                          if (schedule == null) return;
                                          if (!modalContext.mounted) return;
                                          final timeOfDay = TimeOfDay(
                                            hour: schedule.hour,
                                            minute: schedule.minute,
                                          );
                                          final formatted =
                                              '${schedule.day}/${schedule.month}/${schedule.year} • ${timeOfDay.format(modalContext)}';
                                          if (!modalContext.mounted) return;
                                          Navigator.of(modalContext).pop();
                                          if (!parentContext.mounted) return;
                                          await _showBroadcastResult(
                                            parentContext,
                                            title: 'Broadcast Dijadwalkan',
                                            message:
                                                'Broadcast akan dikirim pada $formatted.',
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: AppColors.primary500,
                                            width: 1.2,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: Responsive.spacing(
                                              modalContext,
                                              12,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              Responsive.borderRadius(
                                                modalContext,
                                                4,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Jadwalkan',
                                          style: TextStyle(
                                            fontFamily: 'SFProDisplay',
                                            fontWeight: FontWeight.w600,
                                            fontSize: Responsive.fontSize(
                                              modalContext,
                                              16,
                                            ),
                                            color: AppColors.primary500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Responsive.spacing(
                                        modalContext,
                                        12,
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(modalContext).pop();
                                          if (!parentContext.mounted) return;
                                          await _showBroadcastResult(
                                            parentContext,
                                            title: 'Broadcast Diposting',
                                            message:
                                                'Broadcast berhasil dibuat dan dipublikasikan.',
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary500,
                                          padding: EdgeInsets.symmetric(
                                            vertical: Responsive.spacing(
                                              modalContext,
                                              12,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              Responsive.borderRadius(
                                                modalContext,
                                                4,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Post',
                                          style: TextStyle(
                                            fontFamily: 'SFProDisplay',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: Responsive.fontSize(
                                              modalContext,
                                              16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
  }

  Future<String?> _showOptionPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                Responsive.horizontalPadding(context),
                Responsive.spacing(context, 20),
                Responsive.horizontalPadding(context),
                Responsive.spacing(context, 20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.fontSize(context, 18),
                      color: AppColors.text500,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, 12)),
                  ...options.map(
                    (option) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        option,
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: Responsive.fontSize(context, 15),
                          color: AppColors.text500,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop(option),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BroadcastCard extends StatelessWidget {
  final _BroadcastItem item;
  final bool isCompact;

  const _BroadcastCard({required this.item, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(Responsive.spacing(context, 18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: Responsive.fontSize(context, isCompact ? 15 : 16),
              height: 1.4,
              letterSpacing: 0.5,
              color: AppColors.text500,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 6)),
          Text(
            item.description,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w400,
              fontSize: Responsive.fontSize(context, 14),
              height: 1.5,
              letterSpacing: 0.3,
              color: AppColors.text400,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 12)),
          const Divider(height: 1, color: Color(0xFFE9EBF1)),
          SizedBox(height: Responsive.spacing(context, 12)),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: item.avatarColor,
                radius: Responsive.spacing(context, 16),
                child: Text(
                  item.avatarLabel,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.fontSize(context, 14),
                    color: AppColors.text500,
                  ),
                ),
              ),
              SizedBox(width: Responsive.spacing(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.author,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.fontSize(context, 14),
                        color: AppColors.text500,
                      ),
                    ),
                    SizedBox(height: Responsive.spacing(context, 2)),
                    Text(
                      item.timestamp,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontWeight: FontWeight.w400,
                        fontSize: Responsive.fontSize(context, 12),
                        color: AppColors.text400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BroadcastItem {
  final String title;
  final String description;
  final String author;
  final String timestamp;
  final String avatarLabel;
  final Color avatarColor;

  const _BroadcastItem({
    required this.title,
    required this.description,
    required this.author,
    required this.timestamp,
    required this.avatarLabel,
    required this.avatarColor,
  });
}

class _BroadcastTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxLines;

  const _BroadcastTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 4),
        ),
        border: Border.all(color: const Color(0xFFE4E6EB)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, 16),
        vertical: Responsive.spacing(context, 10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: Responsive.fontSize(context, 13),
              color: AppColors.text300,
            ),
          ),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: Responsive.fontSize(context, 15),
              color: const Color(0xFF222222),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'SFProDisplay',
                fontSize: Responsive.fontSize(context, 15),
                color: AppColors.text500,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class _BroadcastSelectField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _BroadcastSelectField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.borderRadius(context, 4),
          ),
          border: Border.all(color: const Color(0xFFE4E6EB)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, 16),
          vertical: Responsive.spacing(context, 14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: Responsive.fontSize(context, 13),
                      color: AppColors.text300,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, 2)),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: Responsive.fontSize(context, 15),
                      color: AppColors.text500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.text300),
          ],
        ),
      ),
    );
  }
}

Future<TimeOfDay?> _pickTime(
  BuildContext context, {
  required TimeOfDay initial,
}) {
  return showTimePicker(
    context: context,
    initialTime: initial,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          timePickerTheme: const TimePickerThemeData(
            hourMinuteTextColor: AppColors.text500,
          ),
        ),
        child: child ?? const SizedBox.shrink(),
      );
    },
  );
}

Future<DateTime?> _pickScheduleDateTime(BuildContext context) async {
  final now = DateTime.now();
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: now,
    lastDate: DateTime(now.year + 1),
  );
  if (pickedDate == null) return null;
  if (!context.mounted) return null;

  final pickedTime = await _pickTime(
    context,
    initial: TimeOfDay.fromDateTime(now),
  );
  if (pickedTime == null) return null;

  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}

Future<void> _showBroadcastResult(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(Responsive.spacing(context, 24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary500,
                size: Responsive.iconSize(context, 44),
              ),
              SizedBox(height: Responsive.spacing(context, 16)),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.fontSize(context, 18),
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, 8)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontSize: Responsive.fontSize(context, 14),
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, 16)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Tutup',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.fontSize(context, 16),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

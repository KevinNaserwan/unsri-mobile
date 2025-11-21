import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'tap_in_selfie_screen.dart';

class TapInMapScreen extends StatefulWidget {
  final UserProfile profile;
  final bool isTappedIn;

  const TapInMapScreen({
    super.key,
    required this.profile,
    this.isTappedIn = false,
  });

  @override
  State<TapInMapScreen> createState() => _TapInMapScreenState();
}

class _TapInMapScreenState extends State<TapInMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _requestLocationAndUpdate();
  }

  Future<void> _requestLocationAndUpdate() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await _updateLocation();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Akses lokasi diperlukan untuk menggunakan fitur ini',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
      // Use default location if permission denied
      setState(() {
        _currentLocation = const LatLng(-2.983333, 104.7425);
      });
    }
  }

  Future<void> _updateLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });

        _mapController.move(_currentLocation!, 16.0);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui lokasi: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final currentLocation =
        _currentLocation ?? const LatLng(-2.983333, 104.7425);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 16,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.unsri.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation,
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.primary500,
                          size: Responsive.iconSize(context, 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66000000),
                    Color(0x00000000),
                    Color(0x66000000),
                  ],
                  stops: [0, 0.4, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _TopCard(
                    profile: widget.profile,
                    isTappedIn: widget.isTappedIn,
                  ),
                  const Spacer(),
                  _BottomCard(
                    isLoading: _isLoadingLocation,
                    isTappedIn: widget.isTappedIn,
                    onUpdateLocation: _updateLocation,
                    onNavigateSelfie: () async {
                      if (!mounted) return;
                      final navigator = Navigator.of(context);
                      final result = await navigator.push(
                        MaterialPageRoute(
                          builder: (_) => TapInSelfieScreen(
                            profile: widget.profile,
                            isTappedIn: widget.isTappedIn,
                          ),
                        ),
                      );
                      if (!mounted) return;
                      // If selfie screen returns true, pop map screen to return to home
                      if (result == true) {
                        navigator.pop(true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  final UserProfile profile;
  final bool isTappedIn;

  const _TopCard({required this.profile, required this.isTappedIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, 16),
        vertical: Responsive.spacing(context, 8),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isTappedIn ? 'Tap Out' : 'Tap In',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.fontSize(context, 20),
                  color: AppColors.text500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomCard extends StatelessWidget {
  final bool isLoading;
  final bool isTappedIn;
  final VoidCallback onUpdateLocation;
  final VoidCallback onNavigateSelfie;

  const _BottomCard({
    required this.isLoading,
    required this.isTappedIn,
    required this.onUpdateLocation,
    required this.onNavigateSelfie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.spacing(context, 18)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, 12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sesuaikan titik lokasi di peta dengan posisi Anda saat ini.',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: Responsive.fontSize(context, 16),
              color: AppColors.text500,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 8)),
          Text(
            'Gunakan tombol perbarui untuk memverifikasi posisi Anda sebelum ambil selfie.',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontSize: Responsive.fontSize(context, 14),
              color: AppColors.text400,
              height: 1.5,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 14)),
          Container(
            padding: EdgeInsets.all(Responsive.spacing(context, 12)),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6FF),
              borderRadius: BorderRadius.circular(
                Responsive.borderRadius(context, 4),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info500),
                SizedBox(width: Responsive.spacing(context, 8)),
                Expanded(
                  child: Text(
                    'Pastikan kamu terhubung ke WiFi UNSRI.',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: Responsive.fontSize(context, 13),
                      color: AppColors.info600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 14)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : onUpdateLocation,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: Responsive.spacing(context, 12),
                    ),
                    side: const BorderSide(color: AppColors.primary500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.borderRadius(context, 4),
                      ),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: Responsive.iconSize(context, 20),
                          width: Responsive.iconSize(context, 20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary500,
                            ),
                          ),
                        )
                      : Text(
                          'Perbarui Lokasi',
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w600,
                            fontSize: Responsive.fontSize(context, 15),
                            color: AppColors.primary500,
                          ),
                        ),
                ),
              ),
              SizedBox(width: Responsive.spacing(context, 12)),
              Expanded(
                child: ElevatedButton(
                  onPressed: onNavigateSelfie,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    padding: EdgeInsets.symmetric(
                      vertical: Responsive.spacing(context, 12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.borderRadius(context, 4),
                      ),
                    ),
                  ),
                  child: Text(
                    isTappedIn ? 'Tap Out' : 'Ambil Selfie',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.fontSize(context, 15),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

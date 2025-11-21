import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/app_colors.dart';
import '../utils/responsive.dart';

class AttendanceScannerScreen extends StatefulWidget {
  const AttendanceScannerScreen({super.key});

  @override
  State<AttendanceScannerScreen> createState() =>
      _AttendanceScannerScreenState();
}

class _AttendanceScannerScreenState extends State<AttendanceScannerScreen> {
  MobileScannerController? _controller;

  bool _isScanning = true;
  bool _hasPermission = false;
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      // Initialize and start camera after permission is granted
      _controller ??= MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
      );
      await _controller!.start();
    }

    if (mounted) {
      setState(() {
        _hasPermission = status.isGranted;
        _isCheckingPermission = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodeCapture) {
    if (!_isScanning) return;

    final List<Barcode> barcodes = barcodeCapture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
        setState(() {
          _isScanning = false;
        });

        // Stop scanning
        _controller?.stop();

        // Show result dialog or handle the scanned code
        _showScanResult(barcode.rawValue!);
      }
    }
  }

  void _showScanResult(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Terdeteksi'),
        content: Text('Kode: $code'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Resume scanning
              setState(() {
                _isScanning = true;
              });
              _controller?.start();
            },
            child: const Text('Scan Lagi'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Process attendance with the scanned code
              Navigator.of(context).pop(); // Close scanner screen
            },
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Camera scanner or permission message
            Expanded(
              child: _isCheckingPermission
                  ? _buildLoadingView(context)
                  : _hasPermission && _controller != null
                  ? Stack(
                      children: [
                        // Camera view
                        MobileScanner(
                          controller: _controller!,
                          onDetect: _handleBarcode,
                        ),
                        // Overlay with scanning area
                        _buildScanningOverlay(context),
                      ],
                    )
                  : _buildPermissionDeniedView(context),
            ),
            // Bottom information card
            if (_hasPermission) _buildBottomCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          SizedBox(height: Responsive.spacing(context, 16)),
          Text(
            'Meminta akses kamera...',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w400,
              fontSize: Responsive.fontSize(context, 14),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedView(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: Responsive.iconSize(context, 64),
              color: Colors.white,
            ),
            SizedBox(height: Responsive.spacing(context, 24)),
            Text(
              'Akses Kamera Diperlukan',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w600,
                fontSize: Responsive.fontSize(context, 18),
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.spacing(context, 12)),
            Text(
              'Aplikasi memerlukan akses kamera untuk memindai QR Code absensi. Silakan berikan izin kamera di pengaturan.',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.w400,
                fontSize: Responsive.fontSize(context, 14),
                color: Colors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.spacing(context, 32)),
            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
                // Wait a bit for user to return from settings
                await Future.delayed(const Duration(milliseconds: 500));
                // Check permission again after user returns
                await _requestCameraPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, 24),
                  vertical: Responsive.spacing(context, 12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.borderRadius(context, 8),
                  ),
                ),
              ),
              child: Text(
                'Buka Pengaturan',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.fontSize(context, 16),
                ),
              ),
            ),
            SizedBox(height: Responsive.spacing(context, 16)),
            TextButton(
              onPressed: () async {
                await _requestCameraPermission();
              },
              child: Text(
                'Coba Lagi',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w400,
                  fontSize: Responsive.fontSize(context, 14),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);
    final topPad = Responsive.topPadding(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: horizontalPad,
        right: horizontalPad,
        top: topPad,
        bottom: Responsive.spacing(context, 16),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.chevron_left,
              size: Responsive.iconSize(context, 24),
              color: AppColors.text500,
            ),
          ),
          SizedBox(width: Responsive.spacing(context, 12)),
          Text(
            'Absensi Perkuliahan',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w500,
              fontSize: Responsive.fontSize(context, 18),
              color: AppColors.text500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final scanAreaSize = screenWidth * 0.7; // 70% of screen width

        // Calculate center position
        final topOffset = (screenHeight - scanAreaSize) / 2;
        final leftOffset = (screenWidth - scanAreaSize) / 2;

        final scanArea = Rect.fromLTWH(
          leftOffset,
          topOffset,
          scanAreaSize,
          scanAreaSize,
        );

        return Stack(
          children: [
            // Dark overlay
            Positioned.fill(
              child: CustomPaint(
                painter: _ScanningOverlayPainter(scanArea: scanArea),
              ),
            ),
            // Scanning frame
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: Container(
                width: scanAreaSize,
                height: scanAreaSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(
                    Responsive.borderRadius(context, 12),
                  ),
                ),
                child: Stack(
                  children: [
                    // Corner indicators
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.white, width: 4),
                            left: BorderSide(color: Colors.white, width: 4),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.white, width: 4),
                            right: BorderSide(color: Colors.white, width: 4),
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white, width: 4),
                            left: BorderSide(color: Colors.white, width: 4),
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white, width: 4),
                            right: BorderSide(color: Colors.white, width: 4),
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomCard(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Responsive.borderRadius(context, 20)),
          topRight: Radius.circular(Responsive.borderRadius(context, 20)),
        ),
      ),
      padding: EdgeInsets.all(horizontalPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'Scan QR Absensi',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              fontSize: Responsive.fontSize(context, 18),
              color: AppColors.text500,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 12)),
          // Instructions
          Text(
            'Arahkan kamera ke QR Code yang ditampilkan dosen untuk mencatat kehadiranmu.',
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w400,
              fontSize: Responsive.fontSize(context, 14),
              height: 1.5,
              color: AppColors.text500,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 16)),
          // Info box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.spacing(context, 12)),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F4FF),
              borderRadius: BorderRadius.circular(
                Responsive.borderRadius(context, 8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: Responsive.iconSize(context, 20),
                  color: AppColors.info500,
                ),
                SizedBox(width: Responsive.spacing(context, 8)),
                Expanded(
                  child: Text(
                    'Pastikan kamu terhubung ke WiFi UNSRI.',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: Responsive.fontSize(context, 14),
                      color: AppColors.info500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 20)),
          // Report button
          SizedBox(
            width: double.infinity,
            height: Responsive.buttonHeight(context),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Handle report issue
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.borderRadius(context, 8),
                  ),
                ),
                elevation: 0,
              ),
              child: Text(
                'Laporkan Kendala',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.fontSize(context, 16),
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, 20)),
        ],
      ),
    );
  }
}

class _ScanningOverlayPainter extends CustomPainter {
  final Rect scanArea;

  _ScanningOverlayPainter({required this.scanArea});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Draw dark overlay on all sides
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Cut out the scanning area
    final scanPath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanArea, const Radius.circular(12)));

    final combinedPath = Path.combine(PathOperation.difference, path, scanPath);

    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

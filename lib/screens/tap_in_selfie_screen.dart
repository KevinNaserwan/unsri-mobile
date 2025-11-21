import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../utils/tap_in_state.dart';

class TapInSelfieScreen extends StatefulWidget {
  final UserProfile profile;
  final bool isTappedIn;

  const TapInSelfieScreen({
    super.key,
    required this.profile,
    this.isTappedIn = false,
  });

  @override
  State<TapInSelfieScreen> createState() => _TapInSelfieScreenState();
}

class _TapInSelfieScreenState extends State<TapInSelfieScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  XFile? _capturedImage;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Dispose existing controller if any
    await _disposeCamera();

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akses kamera diperlukan untuk mengambil selfie'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak ada kamera yang tersedia'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menginisialisasi kamera: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      await _disposeCamera();
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      if (mounted) {
        setState(() {
          _capturedImage = image;
          _showPreview = true;
          _isCapturing = false;
        });
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil foto: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _showSuccessDialog() async {
    // Update state based on tap in/out
    if (widget.isTappedIn) {
      TapInState.setCheckOut();
    } else {
      TapInState.setCheckIn();
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(Responsive.spacing(context, 24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Responsive.iconSize(context, 60),
                  height: Responsive.iconSize(context, 60),
                  decoration: BoxDecoration(
                    color: AppColors.primary500,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: Responsive.iconSize(context, 36),
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, 16)),
                Text(
                  widget.isTappedIn ? 'Tap Out Berhasil!' : 'Tap In Berhasil!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.fontSize(context, 20),
                    color: AppColors.text500,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, 8)),
                Text(
                  'Kehadiran Anda berhasil dicatat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontSize: Responsive.fontSize(context, 14),
                    color: AppColors.text400,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, 24)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Close dialog first
                      Navigator.of(dialogContext).pop();
                      // Pop selfie screen and return true to map screen
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.spacing(context, 12),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Responsive.borderRadius(context, 12),
                        ),
                      ),
                    ),
                    child: Text(
                      'Selesai',
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

  @override
  void dispose() {
    _disposeCamera();
    super.dispose();
  }

  Future<void> _disposeCamera() async {
    if (_cameraController != null) {
      try {
        if (_cameraController!.value.isInitialized) {
          await _cameraController!.dispose();
        }
      } catch (e) {
        // Ignore disposal errors - camera might already be disposed
      } finally {
        _cameraController = null;
        if (mounted) {
          setState(() {
            _isCameraInitialized = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0508),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
                vertical: Responsive.spacing(context, 8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: Responsive.iconSize(context, 24),
                    ),
                  ),
                  SizedBox(width: Responsive.spacing(context, 4)),
                  Text(
                    widget.isTappedIn ? 'Tap Out' : 'Ambil Selfie',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.fontSize(context, 20),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Scan circle - bigger and centered
                    Container(
                      width: Responsive.imageSize(
                        context,
                        mobile: 320,
                        tablet: 400,
                      ),
                      height: Responsive.imageSize(
                        context,
                        mobile: 320,
                        tablet: 400,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 3,
                        ),
                      ),
                    ),
                    // Camera preview or captured image
                    ClipOval(
                      child: SizedBox(
                        width: Responsive.imageSize(
                          context,
                          mobile: 280,
                          tablet: 360,
                        ),
                        height: Responsive.imageSize(
                          context,
                          mobile: 280,
                          tablet: 360,
                        ),
                        child: _showPreview && _capturedImage != null
                            ? Image.file(
                                File(_capturedImage!.path),
                                fit: BoxFit.cover,
                              )
                            : _isCameraInitialized && _cameraController != null
                            ? _cameraController!.value.isInitialized
                                  ? Transform.scale(
                                      scaleX: -1.0, // Mirror for front camera
                                      child: AspectRatio(
                                        aspectRatio: _cameraController!
                                            .value
                                            .aspectRatio,
                                        child: CameraPreview(
                                          _cameraController!,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.black,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                            : Container(
                                color: Colors.black,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                Responsive.horizontalPadding(context),
                Responsive.spacing(context, 24),
                Responsive.horizontalPadding(context),
                Responsive.spacing(context, 32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ambil Foto Diri untuk Verifikasi',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.fontSize(context, 17),
                      color: AppColors.text500,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, 8)),
                  _buildInstruction(context, 'Wajah jelas, tidak terhalang'),
                  _buildInstruction(
                    context,
                    'Pencahayaan terang, bukan membelakangi cahaya',
                  ),
                  _buildInstruction(
                    context,
                    'Latar bersih dan tidak berantakan',
                  ),
                  _buildInstruction(
                    context,
                    'Kamera stabil, hasil foto tidak buram',
                  ),
                  SizedBox(height: Responsive.spacing(context, 20)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCapturing || !_isCameraInitialized
                          ? null
                          : _captureImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.spacing(context, 14),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Responsive.borderRadius(context, 4),
                          ),
                        ),
                      ),
                      child: _isCapturing
                          ? SizedBox(
                              height: Responsive.iconSize(context, 20),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/camera.png',
                                  width: Responsive.iconSize(context, 24),
                                  height: Responsive.iconSize(context, 24),
                                  color: Colors.white,
                                ),
                                SizedBox(width: Responsive.spacing(context, 8)),
                                Text(
                                  widget.isTappedIn
                                      ? 'Tap Out'
                                      : 'Ambil Selfie',
                                  style: TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w600,
                                    fontSize: Responsive.fontSize(context, 16),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.spacing(context, 6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: AppColors.text400,
              fontSize: Responsive.fontSize(context, 16),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontSize: Responsive.fontSize(context, 14),
                color: AppColors.text400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

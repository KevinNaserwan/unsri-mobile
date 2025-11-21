import 'package:flutter/material.dart';

import '../models/app_role.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'home_screen.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  final AuthMode initialMode;

  const AuthScreen({super.key, this.initialMode = AuthMode.login});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final List<_DummyAccount> _dummyAccounts = const [
    _DummyAccount(
      email: 'mahasiswa@unsri.ac.id',
      password: 'mahasiswa123',
      profile: UserProfile(
        name: 'Erika Nur Hasanah',
        subtitle: 'NIM 09031382126124',
        role: AppRole.mahasiswa,
        avatarPath: 'assets/photos/dummy-photo.jpg',
      ),
    ),
    _DummyAccount(
      email: 'dosen@unsri.ac.id',
      password: 'dosen123',
      profile: UserProfile(
        name: 'Pak Abdiansyah',
        subtitle: 'NIP 0001108401121345',
        role: AppRole.dosen,
        avatarPath: 'assets/photos/dummy-dosen.jpg',
      ),
    ),
    _DummyAccount(
      email: 'admin@unsri.ac.id',
      password: 'admin123',
      profile: UserProfile(
        name: 'Admin UNSRI',
        subtitle: 'UNSRI Ketatausahaan',
        role: AppRole.admin,
        avatarPath: 'assets/photos/dummy-photo.jpg',
      ),
    ),
  ];

  late AuthMode _currentMode;

  // Login controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  bool _obscureLoginPassword = true;

  // Register controllers
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();
  bool _obscureRegisterPassword = true;
  bool _obscureRegisterConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.initialMode;
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  static TextStyle _headingStyle(BuildContext context) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: FontWeight.w500,
    fontSize: Responsive.fontSize(context, 18),
    height: 1.5,
    letterSpacing: 0.5,
    color: AppColors.text500,
  );

  static TextStyle _bodyStyle(BuildContext context) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: FontWeight.w500,
    fontSize: Responsive.fontSize(context, 16),
    height: 1.5,
    letterSpacing: 0.5,
    color: AppColors.text500,
  );

  static TextStyle _labelStyle(BuildContext context) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: FontWeight.w500,
    fontSize: Responsive.fontSize(context, 14),
    color: AppColors.text500,
  );

  static TextStyle _buttonTextStyle(BuildContext context) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: FontWeight.w500,
    fontSize: Responsive.fontSize(context, 16),
    height: 1.5,
    letterSpacing: 0.5,
  );

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);
    final topPad = Responsive.topPadding(context);
    final spacing8 = Responsive.spacing(context, 8.0);
    final spacing12 = Responsive.spacing(context, 12.0);
    final spacing16 = Responsive.spacing(context, 16.0);
    final spacing24 = Responsive.spacing(context, 24.0);
    final buttonHeight = Responsive.buttonHeight(context);
    final borderRadius = Responsive.borderRadius(context, 12);
    final tabBorderRadius = Responsive.borderRadius(context, 8);
    final logoSize = Responsive.logoSize(
      context,
      mobile: 80,
      tablet: 100,
      desktop: 120,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top tabs
            Container(
              color: const Color(0xFFFFFFFF),
              padding: EdgeInsets.only(
                top: topPad,
                left: horizontalPad,
                right: horizontalPad,
                bottom: spacing8,
              ),
              child: Container(
                padding: EdgeInsets.all(spacing8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(tabBorderRadius),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentMode = AuthMode.register;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: spacing12),
                          decoration: BoxDecoration(
                            color: _currentMode == AuthMode.register
                                ? AppColors.primary500
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              tabBorderRadius,
                            ),
                          ),
                          child: Text(
                            'Daftar Akun',
                            textAlign: TextAlign.center,
                            style: _bodyStyle(context).copyWith(
                              color: _currentMode == AuthMode.register
                                  ? Colors.white
                                  : AppColors.text300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentMode = AuthMode.login;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: spacing12),
                          decoration: BoxDecoration(
                            color: _currentMode == AuthMode.login
                                ? AppColors.primary500
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              tabBorderRadius,
                            ),
                          ),
                          child: Text(
                            'Masuk',
                            textAlign: TextAlign.center,
                            style: _bodyStyle(context).copyWith(
                              color: _currentMode == AuthMode.login
                                  ? Colors.white
                                  : AppColors.text300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: spacing16),

                            // Logo and content
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPad,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Logo
                                  Image.asset(
                                    'assets/logos/logo.png',
                                    width: logoSize,
                                    height: logoSize,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  SizedBox(width: spacing16),
                                  // Title and description
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _currentMode == AuthMode.login
                                              ? 'Masuk ke UNSRI Mobile'
                                              : 'Daftar ke UNSRI Mobile',
                                          style: _headingStyle(context),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          _currentMode == AuthMode.login
                                              ? 'Gunakan akun resmi UNSRI (SIMAK) untuk masuk ke aplikasi.'
                                              : 'Buat akun baru untuk mengakses layanan UNSRI Mobile.',
                                          style: _bodyStyle(
                                            context,
                                          ).copyWith(color: AppColors.text400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: spacing16),

                            // Form fields - switch between login and register
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPad,
                                ),
                                child: _currentMode == AuthMode.login
                                    ? _buildLoginForm(
                                        context,
                                        horizontalPad,
                                        spacing12,
                                        spacing16,
                                        spacing24,
                                        buttonHeight,
                                        borderRadius,
                                      )
                                    : _buildRegisterForm(
                                        context,
                                        horizontalPad,
                                        spacing12,
                                        spacing16,
                                        spacing24,
                                        buttonHeight,
                                        borderRadius,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToHome(UserProfile profile) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomeScreen(profile: profile)),
      (route) => false,
    );
  }

  void _attemptLogin() {
    final email = _loginEmailController.text.trim().toLowerCase();
    final password = _loginPasswordController.text;
    final account = _dummyAccounts.firstWhere(
      (acc) => acc.email == email,
      orElse: () => const _DummyAccount.empty(),
    );

    if (account.isEmpty || account.password != password) {
      _showInfo(
        'Gunakan akun dummy:\nMahasiswa: mahasiswa@unsri.ac.id / mahasiswa123\n'
        'Dosen: dosen@unsri.ac.id / dosen123\nAdmin: admin@unsri.ac.id / admin123',
      );
      return;
    }

    _goToHome(account.profile);
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    double horizontalPad,
    double spacing12,
    double spacing16,
    double spacing24,
    double buttonHeight,
    double borderRadius,
  ) {
    final bottomSpacing = Responsive.spacing(context, 24.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email/NIM field
        Text('Email UNSRI/ NIM', style: _labelStyle(context)),
        SizedBox(height: spacing12),
        TextField(
          controller: _loginEmailController,
          decoration: InputDecoration(
            hintText: 'Masukkan Email UNSRI/ NIM',
            hintStyle: TextStyle(
              color: AppColors.text300,
              fontFamily: 'SFProDisplay',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.primary500, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing16,
              vertical: spacing16,
            ),
          ),
          style: _bodyStyle(context),
        ),
        SizedBox(height: spacing16),

        // Password field
        Text('Kata Sandi', style: _labelStyle(context)),
        SizedBox(height: spacing12),
        TextField(
          controller: _loginPasswordController,
          obscureText: _obscureLoginPassword,
          decoration: InputDecoration(
            hintText: 'Masukkan Kata Sandi',
            hintStyle: TextStyle(
              color: AppColors.text300,
              fontFamily: 'SFProDisplay',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.primary500, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing16,
              vertical: spacing16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureLoginPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.text400,
              ),
              onPressed: () {
                setState(() {
                  _obscureLoginPassword = !_obscureLoginPassword;
                });
              },
            ),
          ),
          style: _bodyStyle(context),
        ),
        SizedBox(height: spacing12),

        // Forgot password link - rata kiri
        TextButton(
          onPressed: () {
            // TODO: Navigate to forgot password screen
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Lupa kata sandi?',
            style: _bodyStyle(context).copyWith(color: const Color(0xFF7A7A7A)),
          ),
        ),

        // Spacer to push button to bottom
        const Spacer(),

        SizedBox(height: bottomSpacing),

        // Login button at bottom
        Padding(
          padding: EdgeInsets.only(bottom: spacing24),
          child: SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: _attemptLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: 0,
              ),
              child: Text(
                'Masuk',
                style: _buttonTextStyle(context).copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(
    BuildContext context,
    double horizontalPad,
    double spacing12,
    double spacing16,
    double spacing24,
    double buttonHeight,
    double borderRadius,
  ) {
    final bottomSpacing = Responsive.spacing(context, 24.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email/NIM field
        Text('Email UNSRI/ NIM', style: _labelStyle(context)),
        SizedBox(height: spacing12),
        TextField(
          controller: _registerEmailController,
          decoration: InputDecoration(
            hintText: 'Masukkan Email UNSRI/ NIM',
            hintStyle: TextStyle(
              color: AppColors.text300,
              fontFamily: 'SFProDisplay',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.primary500, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing16,
              vertical: spacing16,
            ),
          ),
          style: _bodyStyle(context),
        ),
        SizedBox(height: spacing16),

        // Password field
        Text('Kata Sandi', style: _labelStyle(context)),
        SizedBox(height: spacing12),
        TextField(
          controller: _registerPasswordController,
          obscureText: _obscureRegisterPassword,
          decoration: InputDecoration(
            hintText: 'Masukkan Kata Sandi',
            hintStyle: TextStyle(
              color: AppColors.text300,
              fontFamily: 'SFProDisplay',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.primary500, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing16,
              vertical: spacing16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureRegisterPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.text400,
              ),
              onPressed: () {
                setState(() {
                  _obscureRegisterPassword = !_obscureRegisterPassword;
                });
              },
            ),
          ),
          style: _bodyStyle(context),
        ),
        SizedBox(height: spacing16),

        // Confirm Password field
        Text('Konfirmasi Kata Sandi', style: _labelStyle(context)),
        SizedBox(height: spacing12),
        TextField(
          controller: _registerConfirmPasswordController,
          obscureText: _obscureRegisterConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Masukkan Ulang Kata Sandi',
            hintStyle: TextStyle(
              color: AppColors.text300,
              fontFamily: 'SFProDisplay',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.text300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.primary500, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing16,
              vertical: spacing16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureRegisterConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.text400,
              ),
              onPressed: () {
                setState(() {
                  _obscureRegisterConfirmPassword =
                      !_obscureRegisterConfirmPassword;
                });
              },
            ),
          ),
          style: _bodyStyle(context),
        ),
        SizedBox(height: spacing12),

        // Login link - rata kiri
        Row(
          children: [
            Text(
              'Sudah punya akun? ',
              style: _bodyStyle(
                context,
              ).copyWith(color: const Color(0xFF7A7A7A)),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentMode = AuthMode.login;
                });
              },
              child: Text(
                'Masuk',
                style: _bodyStyle(
                  context,
                ).copyWith(color: const Color(0xFF7A7A7A)),
              ),
            ),
          ],
        ),

        // Spacer to push buttons to bottom
        const Spacer(),

        SizedBox(height: bottomSpacing),

        // Bottom buttons for register at bottom
        Padding(
          padding: EdgeInsets.only(bottom: spacing24),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showInfo(
                    'Silakan hubungi admin UNSRI untuk bantuan registrasi.',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: spacing12),
                    minimumSize: Size(0, buttonHeight),
                    side: BorderSide(color: AppColors.primary500, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  child: Text(
                    'Hub Admin',
                    style: _buttonTextStyle(
                      context,
                    ).copyWith(color: AppColors.primary500),
                  ),
                ),
              ),
              SizedBox(width: spacing16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showInfo(
                    'Registrasi belum tersedia. Gunakan akun dummy yang diberikan untuk login.',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: spacing12),
                    minimumSize: Size(0, buttonHeight),
                    backgroundColor: AppColors.primary500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Daftar Akun',
                    style: _buttonTextStyle(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DummyAccount {
  final String email;
  final String password;
  final UserProfile profile;

  const _DummyAccount({
    required this.email,
    required this.password,
    required this.profile,
  });

  const _DummyAccount.empty()
      : email = '',
        password = '',
        profile = const UserProfile(
          name: '',
          subtitle: '',
          role: AppRole.mahasiswa,
          avatarPath: 'assets/photos/dummy-photo.jpg',
        );

  bool get isEmpty => email.isEmpty;
}

enum AppRole { mahasiswa, dosen, admin }

extension AppRoleLabel on AppRole {
  String get navLabel {
    switch (this) {
      case AppRole.mahasiswa:
        return 'Mahasiswa';
      case AppRole.dosen:
        return 'Dosen';
      case AppRole.admin:
        return 'Staff';
    }
  }
}

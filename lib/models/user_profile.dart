import 'app_role.dart';

class UserProfile {
  final String name;
  final String subtitle;
  final AppRole role;
  final String avatarPath;

  const UserProfile({
    required this.name,
    required this.subtitle,
    required this.role,
    this.avatarPath = 'assets/photos/dummy-photo.jpg',
  });
}

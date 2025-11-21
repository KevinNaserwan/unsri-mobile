/// Utility class for accessing facility icons
class FacilityAssets {
  FacilityAssets._();

  // Facility icon paths
  static const String activity = 'assets/icons/facility/activity.png';
  static const String archiveBook = 'assets/icons/facility/archive-book.png';
  static const String book = 'assets/icons/facility/book.png';
  static const String bus = 'assets/icons/facility/bus.png';
  static const String hospital = 'assets/icons/facility/hospital.png';
  static const String map = 'assets/icons/facility/map.png';
  static const String menuBoard = 'assets/icons/facility/menu-board.png';
  static const String messageAdd = 'assets/icons/facility/message-add.png';
  static const String messageQuestion =
      'assets/icons/facility/message-question.png';
  static const String messageTick = 'assets/icons/facility/message-tick.png';
  static const String money4 = 'assets/icons/facility/money-4.png';
  static const String moneys = 'assets/icons/facility/moneys.png';
  static const String monitorMobile =
      'assets/icons/facility/monitor-mobbile.png';
  static const String noteText = 'assets/icons/facility/note-text.png';
  static const String teacher = 'assets/icons/facility/teacher.png';
  static const String tickSquare = 'assets/icons/facility/tick-square.png';
  static const String user = 'assets/icons/facility/user.png';
  static const String userEdit = 'assets/icons/facility/user-edit.png';

  /// Get all facility icon paths as a list
  static List<String> get allIcons => [
    activity,
    archiveBook,
    book,
    bus,
    hospital,
    map,
    menuBoard,
    messageAdd,
    messageQuestion,
    messageTick,
    money4,
    moneys,
    monitorMobile,
    noteText,
    teacher,
    tickSquare,
    user,
    userEdit,
  ];

  /// Get facility icon path by name (without extension)
  static String? getIconByName(String name) {
    final iconMap = {
      'activity': activity,
      'archive-book': archiveBook,
      'book': book,
      'bus': bus,
      'hospital': hospital,
      'map': map,
      'menu-board': menuBoard,
      'message-add': messageAdd,
      'message-question': messageQuestion,
      'message-tick': messageTick,
      'money-4': money4,
      'moneys': moneys,
      'monitor-mobile': monitorMobile,
      'note-text': noteText,
      'teacher': teacher,
      'tick-square': tickSquare,
      'user': user,
      'user-edit': userEdit,
    };
    return iconMap[name.toLowerCase()];
  }
}

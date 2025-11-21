import 'package:intl/intl.dart';

/// Global state management for Tap In/Out functionality
class TapInState {
  static bool _isTappedIn = false;
  static String? _checkInTime;
  static String? _checkOutTime;
  static bool _hasTappedOut = false; // Track if user has tapped out after tap in

  static bool get isTappedIn => _isTappedIn;
  static String get checkInTime => _checkInTime ?? '-- : --';
  static String get checkOutTime => _checkOutTime ?? '-- : --';
  
  /// Check if user has already tapped in today (even if they tapped out)
  static bool get hasTappedInToday => _checkInTime != null;
  
  /// Check if button should be disabled (both check in and check out times are filled)
  static bool get isButtonDisabled {
    final checkIn = checkInTime;
    final checkOut = checkOutTime;
    return checkIn != '-- : --' && checkOut != '-- : --';
  }

  static void setCheckIn() {
    // If already tapped out, mark as already tapped in (but don't change check in time)
    if (_hasTappedOut) {
      _isTappedIn = true; // Set to true so button shows "Already Tap In"
      return; // Don't update check in time
    }
    _isTappedIn = true;
    _checkInTime = DateFormat('HH:mm').format(DateTime.now());
    _hasTappedOut = false; // Reset when tapping in
  }

  static void setCheckOut() {
    _isTappedIn = false;
    _checkOutTime = DateFormat('HH:mm').format(DateTime.now());
    _hasTappedOut = true; // Mark that user has tapped out
    // Keep check in time even after check out
  }

  static void reset() {
    _isTappedIn = false;
    _checkInTime = null;
    _checkOutTime = null;
    _hasTappedOut = false;
  }
}


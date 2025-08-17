import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/user.dart';

class StorageService with ChangeNotifier {
  final Map<String, List<Event>> _userEvents = {};
  final List<User> _registeredUsers = [];

  List<Event> getRegisteredEvents(String email) {
    return _userEvents[email] ?? [];
  }

  void registerForEvent(String email, Event event) {
    _userEvents.putIfAbsent(email, () => []);
    if (!_userEvents[email]!.any((e) => e.id == event.id)) {
      _userEvents[email]!.add(event);
      notifyListeners();
    }
  }

  void unregisterEvent(String email, String eventId) {
    _userEvents[email]?.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }

  void saveUser(User user) {
    if (!_registeredUsers.any((u) => u.email == user.email)) {
      _registeredUsers.add(user);
    }
  }

  User? getUser(String email) {
    try {
      return _registeredUsers.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  void printAllData() {
    if (kDebugMode) {
      print('=== Storage Contents ===');
      print('Users: $_registeredUsers');
      print('Events: $_userEvents');
    }
  }
}

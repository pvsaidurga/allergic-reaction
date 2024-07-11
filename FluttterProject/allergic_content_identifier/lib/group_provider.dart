import 'package:flutter/material.dart';

class GroupProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<String> _selectedGroups = [];

  List<String> get selectedGroups => _selectedGroups;

  void selectGroup(String group) {
    if (!_selectedGroups.contains(group)) {
      _selectedGroups.add(group);
      notifyListeners();
    }
  }

  void deselectGroup(String group) {
    if (_selectedGroups.contains(group)) {
      _selectedGroups.remove(group);
      notifyListeners();
    }
  }

   void clearSelectedGroups() {
    _selectedGroups.clear();
    notifyListeners();
  }
}

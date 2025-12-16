import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  String? _selectedTopic;

  String? get selectedTopic => _selectedTopic;

  void selectTopic(String? topic) {
    _selectedTopic = topic;
    notifyListeners();
  }

  bool get canStartQuiz => _selectedTopic != null;
}

import 'package:flutter/material.dart';

class QuizHistoryItem {
  final DateTime date;
  final int correct;
  final int total;
  final int score;

  QuizHistoryItem({
    required this.date,
    required this.correct,
    required this.total,
    required this.score,
  });

  int get percent {
    if (total == 0) return 0;
    return ((correct / total) * 100).round();
  }
}

class HomeViewModel extends ChangeNotifier {
  final List<QuizHistoryItem> _history = [];

  List<QuizHistoryItem> get history => List.unmodifiable(_history);

  void addResult({
    required int correct,
    required int total,
    required int score,
  }) {
    _history.insert(
      0,
      QuizHistoryItem(
        date: DateTime.now(),
        correct: correct,
        total: total,
        score: score,
      ),
    );
    notifyListeners();
  }
}

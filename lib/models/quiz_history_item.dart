class QuizHistoryItem {
  final int correct;
  final int total;
  final DateTime date;

  QuizHistoryItem({
    required this.correct,
    required this.total,
    required this.date,
  });

  int get percentage {
    if (total == 0) return 0;
    return ((correct / total) * 100).round();
  }

  String get resultText {
    if (percentage < 50) return 'Нужно подтянуть знания';
    if (percentage < 80) return 'Хороший результат';
    return 'Отлично!';
  }
}

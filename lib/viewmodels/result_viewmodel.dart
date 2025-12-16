class ResultViewModel {
  final int correct;
  final int total;

  ResultViewModel({
    required this.correct,
    required this.total,
  });

  int get percentage => ((correct / total) * 100).round();

  String get resultText {
    if (percentage < 50) return 'Нужно подтянуть знания';
    if (percentage < 80) return 'Хороший результат';
    return 'Отлично!';
  }
}

class AnswerOption {
  final String text;
  final bool isCorrect;

  AnswerOption({
    required this.text,
    required this.isCorrect,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }
}
import 'answer_option.dart';

class Question {
  final String question;
  final List<AnswerOption> answers;

  Question({
    required this.question,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final answersJson = json['answers'] as List<dynamic>? ?? [];

    return Question(
      question: json['question'] as String? ?? '',
      answers: answersJson
          .map((e) => AnswerOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
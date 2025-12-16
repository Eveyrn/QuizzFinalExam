import 'answer_option.dart';

class Question {
  final String question;
  final List<AnswerOption> answers;

  Question({
    required this.question,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      answers: (json['answers'] as List)
          .map((e) => AnswerOption.fromJson(e))
          .toList(),
    );
  }
}

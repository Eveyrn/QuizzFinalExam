import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionRepository {
  Future<List<Question>> loadQuestions() async {
    final jsonString =
    await rootBundle.loadString('assets/questions.json');

    final List data = json.decode(jsonString);

    return data.map((e) => Question.fromJson(e)).toList();
  }
}

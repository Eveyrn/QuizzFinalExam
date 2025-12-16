import 'package:flutter/material.dart';
import '../models/question.dart';
import '../data/question_repository.dart';

class QuizViewModel extends ChangeNotifier {
  final QuestionRepository _repository;

  List<Question> _questions = [];
  int _currentIndex = 0;
  int _correctAnswers = 0;
  int? _selectedAnswer;
  bool _isLoading = true;

  QuizViewModel(this._repository);

  bool get isLoading => _isLoading;
  bool get isFinished => _currentIndex >= _questions.length;

  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int get correctAnswers => _correctAnswers;
  int? get selectedAnswer => _selectedAnswer;

  Question get currentQuestion => _questions[_currentIndex];

  Future<void> loadQuiz() async {
    _isLoading = true;
    notifyListeners();

    _questions = await _repository.loadQuestions();

    _isLoading = false;
    notifyListeners();
  }

  void selectAnswer(int index) {
    if (_selectedAnswer != null) return;

    _selectedAnswer = index;
    if (_questions[_currentIndex].answers[index].isCorrect) {
      _correctAnswers++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_selectedAnswer == null) return;

    _currentIndex++;
    _selectedAnswer = null;
    notifyListeners();
  }
}

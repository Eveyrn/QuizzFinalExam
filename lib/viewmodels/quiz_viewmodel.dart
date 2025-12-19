import 'dart:async';
import 'package:flutter/material.dart';
import '../data/question_repository.dart';
import '../models/question.dart';

class QuizViewModel extends ChangeNotifier {
  final QuestionRepository repository;

  QuizViewModel(this.repository);

  static const int questionDuration = 15;

  List<Question> _questions = [];
  int _currentIndex = 0;
  int _correct = 0;
  int _score = 0;
  int? _selectedIndex;

  int _secondsLeft = questionDuration;
  Timer? _timer;

  bool _isLoading = true;

  // GETTERS
  bool get isLoading => _isLoading;
  int get currentIndex => _currentIndex;
  int get total => _questions.length;
  int get correct => _correct;
  int get score => _score;
  int get secondsLeft => _secondsLeft;
  int? get selectedIndex => _selectedIndex;
  bool get hasSelected => _selectedIndex != null;
  bool get isFinished => _currentIndex >= _questions.length;

  Question get currentQuestion => _questions[_currentIndex];

  // LOAD
  Future<void> loadQuiz() async {
    _isLoading = true;
    notifyListeners();

    _questions = await repository.loadQuestions();
    _currentIndex = 0;
    _correct = 0;
    _score = 0;
    _selectedIndex = null;

    _startTimer();

    _isLoading = false;
    notifyListeners();
  }

  // TIMER — НЕ ОСТАНАВЛИВАЕТСЯ ПРИ ВЫБОРЕ
  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = questionDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsLeft--;

      if (_secondsLeft <= 0) {
        timer.cancel();
        nextQuestion();
      }

      notifyListeners();
    });
  }

  // ANSWER — БЕЗ timer.cancel()
  void selectAnswer(int index) {
    if (_selectedIndex != null) return;

    _selectedIndex = index;

    if (currentQuestion.answers[index].isCorrect) {
      _correct++;
      _score += _secondsLeft * 10;
    }

    notifyListeners();
  }

  // NEXT
  void nextQuestion() {
    _timer?.cancel();

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedIndex = null;
      _startTimer();
    } else {
      _currentIndex++;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

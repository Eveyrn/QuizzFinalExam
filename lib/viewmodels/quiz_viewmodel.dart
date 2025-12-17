import 'dart:async';
import 'package:flutter/material.dart';
import '../data/question_repository.dart';
import '../models/question.dart';

class QuizViewModel extends ChangeNotifier {
  final QuestionRepository _repository;

  QuizViewModel(this._repository);

  List<Question> _questions = [];
  bool _isLoading = true;

  int _currentIndex = 0;
  int _correctAnswers = 0;
  int _score = 0;
  int? _selectedAnswer;

  // ⏱ TIMER
  final int questionDuration = 15;
  int _remainingSeconds = 15;
  Timer? _timer;

  // ─── GETTERS ───────────────────────────────
  bool get isLoading => _isLoading;
  int get currentIndex => _currentIndex;

  int get total => _questions.length;
  int get totalQuestions => total;

  int get correctAnswers => _correctAnswers;
  int get score => _score;

  int? get selectedIndex => _selectedAnswer;
  int? get selectedAnswer => selectedIndex;

  int get remainingSeconds => _remainingSeconds;
  bool get hasSelected => _selectedAnswer != null;

  Question get currentQuestion => _questions[_currentIndex];
  bool get isFinished => _currentIndex >= _questions.length;

  // ─── LOAD ─────────────────────────────────
  Future<void> loadQuiz() async {
    _isLoading = true;
    notifyListeners();

    _questions = await _repository.loadQuestions();

    _currentIndex = 0;
    _correctAnswers = 0;
    _score = 0;
    _selectedAnswer = null;

    _startTimer();

    _isLoading = false;
    notifyListeners();
  }

  // ─── TIMER ────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = questionDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;

      if (_remainingSeconds <= 0) {
        timer.cancel();
        nextQuestion();
      }

      notifyListeners();
    });
  }

  // ─── ANSWER ───────────────────────────────
  void selectAnswer(int index) {
    if (_selectedAnswer != null) return;

    _selectedAnswer = index;
    _timer?.cancel();

    final isCorrect =
        _questions[_currentIndex].answers[index].isCorrect;

    if (isCorrect) {
      _correctAnswers++;
      _score += _remainingSeconds * 10; // 💯 Kahoot-style
    }

    notifyListeners();
  }

  // ─── NEXT ─────────────────────────────────
  void nextQuestion() {
    _timer?.cancel();

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswer = null;
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

import 'package:flutter/material.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final QuizViewModel viewModel;

  const ResultScreen({
    super.key,
    required this.viewModel,
  });

  String _getResultText(double percent) {
    if (percent >= 80) {
      return 'Отлично';
    } else if (percent >= 50) {
      return 'Хорошо';
    } else {
      return 'Нужно подтянуть';
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = viewModel.questions.length;
    final correct = viewModel.correctAnswers;
    final percent = (correct / total) * 100;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Результат'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            Text(
            '$correct из $total',
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontW

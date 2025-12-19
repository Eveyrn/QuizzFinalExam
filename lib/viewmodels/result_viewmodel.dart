import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/quiz_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../ui/screens/home_screen.dart';

class ResultScreen extends StatelessWidget {
  final QuizViewModel quizViewModel;

  const ResultScreen({
    super.key,
    required this.quizViewModel,
  });

  String _getResultText(int percent) {
    if (percent >= 80) return 'Отлично';
    if (percent >= 50) return 'Хорошо';
    return 'Нужно подтянуть';
  }

  @override
  Widget build(BuildContext context) {
    final correct = quizViewModel.correct;
    final total = quizViewModel.total;
    final score = quizViewModel.score;

    final percent =
    total == 0 ? 0 : ((correct / total) * 100).round();

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
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$percent%',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              _getResultText(percent),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              '$score очков',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<HomeViewModel>().addResult(
                    correct: correct,
                    total: total,
                    score: score,
                  );

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                        (_) => false,
                  );
                },
                child: const Text('На главный экран'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final QuizViewModel viewModel;

  const ResultScreen({super.key, required this.viewModel});

  String _getResultText(double percent) {
    if (percent >= 80) return 'Отлично';
    if (percent >= 50) return 'Хорошо';
    return 'Нужно подтянуть';
  }

  @override
  Widget build(BuildContext context) {
    final total = viewModel.total;
    final correct = viewModel.correctAnswers;
    final double percent =
    total == 0 ? 0.0 : (correct / total) * 100.0;

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
            const SizedBox(height: 16),
            Text(
              _getResultText(percent),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
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

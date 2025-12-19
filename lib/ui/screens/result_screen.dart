import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int correct;
  final int total;

  const ResultScreen({
    super.key,
    required this.correct,
    required this.total, required int score,
  });

  @override
  Widget build(BuildContext context) {
    final percent = ((correct / total) * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Результат')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$correct / $total',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$percent%',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: const Text('На главную'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

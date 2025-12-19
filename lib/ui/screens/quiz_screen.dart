import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/quiz_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.isFinished) {
      // СОХРАНЕНИЕ ИСТОРИИ ЗДЕСЬ — 100%
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HomeViewModel>().addResult(
          correct: vm.correct,
          total: vm.total,
          score: vm.score,
        );
      });

      return ResultScreen(
        correct: vm.correct,
        total: vm.total,
        score: vm.score,
      );
    }

    final q = vm.currentQuestion;

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Text('Вопрос ${vm.currentIndex + 1}/${vm.total}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // TIMER
          Padding(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value:
              vm.secondsLeft / QuizViewModel.questionDuration,
              minHeight: 10,
              backgroundColor: Colors.deepPurple.shade300,
              color: Colors.white,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              q.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: q.answers.length,
              itemBuilder: (_, i) {
                final a = q.answers[i];
                final selected = vm.selectedIndex == i;

                Color color = [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.orange
                ][i % 4];

                if (vm.hasSelected) {
                  if (a.isCorrect) {
                    color = Colors.green;
                  } else if (selected) {
                    color = Colors.red.shade900;
                  } else {
                    color = Colors.grey.shade700;
                  }
                }

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: vm.hasSelected
                      ? null
                      : () => vm.selectAnswer(i),
                  child: Text(
                    a.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),

          if (vm.hasSelected)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: vm.nextQuestion,
                  child: const Text('Далее'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

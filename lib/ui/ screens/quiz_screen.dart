import 'package:flutter/material.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  final QuizViewModel viewModel;

  const QuizScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тест'),
        automaticallyImplyLeading: false,
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.isFinished) {
            return ResultScreen(viewModel: viewModel);
          }

          final question = viewModel.currentQuestion;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Вопрос ${viewModel.currentIndex + 1} из ${viewModel.questions.length}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Варианты ответов
                ...List.generate(question.options.length, (index) {
                  final isSelected = viewModel.selectedAnswer == index;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.blue
                            : Colors.grey.shade200,
                        foregroundColor:
                        isSelected ? Colors.white : Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                      ),
                      onPressed: () {
                        viewModel.selectAnswer(index);
                      },
                      child: Text(
                        question.options[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: viewModel.selectedAnswer == null
                        ? null
                        : () {
                      viewModel.nextQuestion();
                    },
                    child: const Text('Следующий вопрос'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

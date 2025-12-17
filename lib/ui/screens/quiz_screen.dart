import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  static const List<Color> answerColors = [
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFFFDD835),
    Color(0xFF43A047),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// ✅ ВАЖНО: если тест окончен — показываем результат
        if (vm.isFinished) {
          return ResultScreen(viewModel: vm);
        }

        final question = vm.currentQuestion;

        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Flutter Quiz'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Вопрос ${vm.currentIndex + 1} из ${vm.total}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      question.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: GridView.builder(
                    itemCount: question.answers.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.35,
                    ),
                    itemBuilder: (context, index) {
                      final isSelected = vm.selectedIndex == index;

                      return GestureDetector(
                        onTap: () => vm.selectAnswer(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: answerColors[index],
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: Colors.black, width: 3)
                                : null,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                question.answers[index].text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                    vm.hasSelected ? () => vm.nextQuestion() : null,
                    child: const Text('Далее'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

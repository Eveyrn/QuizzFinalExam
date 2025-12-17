import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/question_repository.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Quiz'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Проверь знания Dart и Flutter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => QuizViewModel(
                            QuestionRepository(),
                          )..loadQuiz(),
                          child: const QuizScreen(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Начать тест'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

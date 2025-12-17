import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/screens/home_screen.dart';
import 'viewmodels/quiz_viewmodel.dart';
import 'data/question_repository.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => QuizViewModel(QuestionRepository())..loadQuiz(),
      child: const QuizApp(),
    ),
  );
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

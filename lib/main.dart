import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/screens/splash_screen.dart';
import 'viewmodels/home_viewmodel.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        ),
        home: const SplashScreen(), // ← ВАЖНО
      ),
    );
  }
}

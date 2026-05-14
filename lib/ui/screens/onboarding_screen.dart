import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _goalsController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedStudyPlans;
  
  bool _isLoading = false;

  final List<String> _genders = ['Мужской', 'Женский', 'Другой'];
  final List<String> _studyPlansOptions = ['1-2', '3-5', 'Больше 5'];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final prefs = await SharedPreferences.getInstance();
        
        // Save to Firebase
        await FirebaseFirestore.instance.collection('users').add({
          'age': int.tryParse(_ageController.text) ?? 0,
          'gender': _selectedGender,
          'studyPlans': _selectedStudyPlans,
          'goals': _goalsController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        
        // Save local state
        await prefs.setBool('isFirstLaunch', false);
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка сохранения: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добро пожаловать!'),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Кратко о приложении',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Flutter Quiz — это лучшее место для проверки своих знаний по Flutter! Проходите тесты, повышайте уровень и готовьтесь к собеседованиям.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Расскажите немного о себе:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Возраст *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите возраст';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Введите корректное число';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Пол *',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedGender,
                    items: _genders.map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) => value == null ? 'Выберите пол' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Сколько планов обучения? *',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedStudyPlans,
                    items: _studyPlansOptions.map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStudyPlans = value;
                      });
                    },
                    validator: (value) => value == null ? 'Выберите количество планов' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _goalsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Ваши цели (например, найти работу) *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, опишите ваши цели';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _submitForm,
                    child: const Text('Начать обучение', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

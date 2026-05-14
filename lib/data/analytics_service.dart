import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime? _appStartTime;

  void logAppOpen() {
    _appStartTime = DateTime.now();
  }

  Future<void> logAppClose() async {
    if (_appStartTime != null) {
      final sessionDuration = DateTime.now().difference(_appStartTime!);
      await _firestore.collection('analytics').doc('sessions').collection('logs').add({
        'durationSeconds': sessionDuration.inSeconds,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _appStartTime = null; // Reset
    }
  }

  Future<void> logScreenView(String screenName) async {
    await _firestore.collection('analytics').doc('screens').collection('views').add({
      'screenName': screenName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logAnswer(String question, String answer, bool isCorrect) async {
    await _firestore.collection('analytics').doc('answers').collection('logs').add({
      'question': question,
      'answer': answer,
      'isCorrect': isCorrect,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

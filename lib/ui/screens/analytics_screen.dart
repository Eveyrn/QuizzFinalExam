import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Последние сессии'),
            _buildSessionsList(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Ответы (Квизы)'),
            _buildAnswersList(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Популярные экраны'),
            _buildScreensList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildSessionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('analytics')
          .doc('sessions')
          .collection('logs')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Text('Нет данных');
        
        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(Icons.timer),
              title: Text('Длительность: ${data['durationSeconds']} сек'),
              subtitle: Text('Время: ${_formatTimestamp(data['timestamp'])}'),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAnswersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('analytics')
          .doc('answers')
          .collection('logs')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Text('Нет данных');

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final isCorrect = data['isCorrect'] as bool? ?? false;
            return ListTile(
              leading: Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
              ),
              title: Text(data['question'] ?? ''),
              subtitle: Text('Ответ: ${data['answer']}'),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildScreensList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('analytics')
          .doc('screens')
          .collection('views')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Text('Нет данных');

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text('Экран: ${data['screenName']}'),
              subtitle: Text('Время: ${_formatTimestamp(data['timestamp'])}'),
            );
          }).toList(),
        );
      },
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Неизвестно';
    if (timestamp is Timestamp) {
      final dt = timestamp.toDate();
      return '${dt.day}.${dt.month}.${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '';
  }
}

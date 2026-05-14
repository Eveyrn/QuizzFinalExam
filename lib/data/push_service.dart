import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PushService {
  static final PushService _instance = PushService._internal();
  factory PushService() => _instance;
  PushService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<String> _pushMessages = [
    'Новый Flutter-тест уже доступен',
    'Ты не закончил последний квиз',
    'Проверь свои знания Flutter за 5 минут',
    'Сегодня: тест по Widgets и UI',
    'Сможешь пройти тест без ошибок?',
    'Твой рекорд могут побить',
    'У тебя серия из 3 успешных тестов',
    'Новый уровень сложности открыт',
    'Ты уже лучше 72% пользователей',
    'Пора повторить StatefulWidget и StatelessWidget',
    'Mini challenge: Flutter layout за 3 минуты',
    'Ошибка в прошлом тесте всё ещё ждёт тебя',
    'Хочешь проверить себя перед собеседованием?',
  ];

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Web requires a different setup or not supported easily via this plugin without service workers,
    // so we provide default settings for iOS/Android/macOS. Web will silently fail or ignore local notifications.
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future<void> scheduleDailyPushes() async {
    // Schedule 3 pushes a day. Example: 10:00, 15:00, 20:00
    // Cancel all previously scheduled pushes to reset
    await flutterLocalNotificationsPlugin.cancelAll();

    final now = tz.TZDateTime.now(tz.local);
    final random = Random();

    // We will schedule for today and tomorrow to ensure they keep coming,
    // or just schedule them daily.
    // The easiest way is to use zonedSchedule with matchDateTimeComponents
    
    // We pick 3 random messages
    List<String> messagesToSchedule = List.from(_pushMessages)..shuffle();
    
    final times = [
      const TimeOfDay(hour: 10, minute: 0),
      const TimeOfDay(hour: 15, minute: 0),
      const TimeOfDay(hour: 20, minute: 0),
    ];

    for (int i = 0; i < times.length; i++) {
      var time = times[i];
      var message = messagesToSchedule[i];

      var scheduledDate = tz.TZDateTime(
          tz.local, now.year, now.month, now.day, time.hour, time.minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: i,
        title: 'Flutter Quiz',
        body: message,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_push',
            'Daily Push',
            channelDescription: 'Daily Push Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Repeat every day at this time
      );
    }
  }

  // Helper for testing
  Future<void> showTestPush() async {
    final random = Random();
    final message = _pushMessages[random.nextInt(_pushMessages.length)];
    
    await flutterLocalNotificationsPlugin.show(
      id: 999,
      title: 'Тест',
      body: message,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_push',
          'Test Push',
          channelDescription: 'Test Push Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}

class TimeOfDay {
  final int hour;
  final int minute;
  const TimeOfDay({required this.hour, required this.minute});
}

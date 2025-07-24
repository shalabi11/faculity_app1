import 'package:flutter/material.dart';
import 'package:faculity_app2/features/schedule/presentation/screens/schedule_screen.dart';

class ScheduleDashboardScreen extends StatelessWidget {
  const ScheduleDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الجداول الدراسية'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('عرض البرنامج النظري للسنة الأولى'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const ScheduleScreen(
                            scheduleType: 'lab',
                            identifier: 'A', // هذه هي الـ group
                            section: 'B', // <-- قمنا بتمرير الـ section هنا
                          ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('عرض البرنامج العملي للشعبة A'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const ScheduleScreen(
                            scheduleType: 'lab',
                            identifier:
                                'A', // يمكنك تغيير هذا لاحقاً ليكون ديناميكياً
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  bool isExercising = false;
  int currentPhase = 0; // 0: inhale, 1: hold, 2: exhale, 3: hold
  int countdown = 4;
  Timer? _timer;
  late AnimationController _animationController;

  final List<String> phases = ['استنشق', 'احبس', 'ازفر', 'احبس'];
  final List<int> durations = [4, 4, 4, 4];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void startExercise() {
    setState(() {
      isExercising = true;
      currentPhase = 0;
      countdown = durations[0];
    });
    _startPhase();
  }

  void stopExercise() {
    setState(() {
      isExercising = false;
    });
    _timer?.cancel();
    _animationController.stop();
  }

  void _startPhase() {
    _animationController.reset();
    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });

      if (countdown == 0) {
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    _timer?.cancel();
    setState(() {
      currentPhase = (currentPhase + 1) % 4;
      countdown = durations[currentPhase];
    });
    _startPhase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تمارين التنفس'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isExercising) ...[
                const Icon(Icons.air, size: 100, color: Colors.blue),
                const SizedBox(height: 32),
                const Text(
                  'تمرين التنفس 4-4-4-4',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'استنشق لـ 4 ثواني\nاحبس لـ 4 ثواني\nازفر لـ 4 ثواني\nاحبس لـ 4 ثواني',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                CustomButton(
                  text: 'ابدأ التمرين',
                  onPressed: startExercise,
                  icon: Icons.play_arrow,
                ),
              ] else ...[
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      width: 150 + (_animationController.value * 50),
                      height: 150 + (_animationController.value * 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                Text(
                  phases[currentPhase],
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$countdown',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 48),
                CustomButton(
                  text: 'إيقاف',
                  onPressed: stopExercise,
                  color: Colors.grey,
                  icon: Icons.stop,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
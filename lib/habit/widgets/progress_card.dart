import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.completedHabits,
    required this.totalHabits,
    required this.progressPercentage,
  });

  final int completedHabits;
  final int totalHabits;
  final int progressPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFFEA955), Color(0xFFFF7E5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Enlarged Progress circle container
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                // Increased height and width from 80 to 100 for a bigger shape
                height: 100,
                width: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Use CircularPercentIndicator for a more modern and professional look
                    CircularPercentIndicator(
                      radius: 30.0, // Adjust size to fit your Home Screen card
                      lineWidth: 6.0, // Thickness of the progress line
                    
                      percent: progressPercentage / 100,

                      // Smooth animation when the value changes
                      animation: true,
                      animateFromLastPercent: true,
                      circularStrokeCap: CircularStrokeCap.round,

                      // Colors styling
                      progressColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),

                      // Center widget to display the numeric percentage
                      center: Text(
                        "${progressPercentage.toInt()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // Habit completion text details
          Expanded(
            child: Text(
              '$completedHabits of $totalHabits habits completed today!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
          colors: [
            Color(0xFFFEA955),
            Color(0xFFFF7E5F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Enlarged Progress circle container
          SizedBox(
            // Increased height and width from 80 to 100 for a bigger shape
            height: 100, 
            width: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The progress ring
                CircularProgressIndicator(
                  value: progressPercentage / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                  // Increased strokeWidth to 8 to match the larger scale
                  strokeWidth: 8, 
                ),
                // Percentage text with more "breathing room" inside
                Text(
                  '${progressPercentage.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    // Increased font size slightly to match the bigger circle
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
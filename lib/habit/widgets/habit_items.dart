import 'package:flutter/material.dart';

class HabitItem extends StatelessWidget {
  final String title;
  final bool completed;
  // A callback function to notify the parent when the item is tapped
  final VoidCallback onToggle; 

  const HabitItem({
    super.key,
    required this.title,
    required this.completed,
    required this.onToggle, // Making it required for the logic to work
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Triggering the callback when the user taps on the entire card
      onTap: onToggle, 
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          // Background color transitions between light green and white
          color: completed ? const Color(0xFFE9F7EF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Adding a subtle shadow for a better UI look when not completed
          boxShadow: [
            if (!completed)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: completed ? Colors.green : Colors.black,
                  fontWeight: completed ? FontWeight.bold : FontWeight.normal,
                  // Optional: Adding a line-through decoration when completed
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            // Visual feedback icon
            Icon(
              completed ? Icons.check_box_outline_blank_rounded : Icons.check_box_rounded,
              color: completed ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
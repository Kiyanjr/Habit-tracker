import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/models/habit_model.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class GoalDetailsScreen extends StatelessWidget {
  final HabitModel goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final hp = Provider.of<HabitProvider>(context);
    
    // English comment: Calculate stats based on your provider logic
    double progress = hp.calculateGoalProgress(goal);
    bool isAchieved = progress >= 1.0;
    
    int completedDays = goal.completedDays;
    int totalDays = int.tryParse(goal.period.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    int failedDays = (totalDays - completedDays).clamp(0, totalDays);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // English comment: Light grey background like Figma
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Goal: ${goal.goalTitle}",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- CALENDAR SECTION ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(16),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2027, 12, 31),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.month,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: Color(0xFF63E6BE), shape: BoxShape.circle),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- DETAILS LIST ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(goal.goalTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      _buildStatusBadge(isAchieved),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _row("Habit Name:", goal.title),
                  _row("Target:", "$totalDays Days"),
                  _row("Days complete:", "$completedDays Days"),
                  _row("Days failed:", "$failedDays Days"),
                  _row("Habit type:", goal.habitType),
                  _row("Created on:", DateFormat('MMMM d, yyyy').format(DateTime.now())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool achieved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: achieved ? const Color(0xFFE6FFF5) : const Color(0xFFFFF4E6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        achieved ? "Achieved" : "In Progress",
        style: TextStyle(
          color: achieved ? const Color(0xFF2ECC71) : Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
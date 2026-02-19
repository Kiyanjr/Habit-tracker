import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class YourGoalsScreen extends StatelessWidget {
  final String filter;
  const YourGoalsScreen({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    // English comment: Filter logic for the list
    final filteredGoals = habitProvider.goals.where((goal) {
      if (filter == 'All Time') return true;
      if (filter == 'This Week') return goal.period.toLowerCase().contains('week') || goal.period.contains('7');
      if (filter == 'This Month') return goal.period.toLowerCase().contains('month') || goal.period.contains('30');
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Your Goals', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(child: Text(filter, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: filteredGoals.length,
        itemBuilder: (context, index) {
          final goal = filteredGoals[index];
          double percent = habitProvider.calculateGoalProgress(goal);
          bool isAchieved = percent >= 1.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
            ),
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: 28.0,
                  lineWidth: 4.0,
                  percent: percent,
                  progressColor: const Color(0xFF63E6BE),
                  backgroundColor: Colors.grey[100]!,
                  center: Text("${(percent * 100).toInt()}%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal.goalTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(habitProvider.getGoalStatusText(goal), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isAchieved ? const Color(0xFFE6FFF5) : const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isAchieved ? "Achieved" : "Unachieved",
                    style: TextStyle(color: isAchieved ? const Color(0xFF2ECC71) : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
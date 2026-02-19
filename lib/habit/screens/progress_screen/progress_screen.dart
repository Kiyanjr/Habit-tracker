import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/models/habit_model.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:habit_tracker/habit/screens/progress_screen/goal_detail_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
// English comment: Ensure this path matches your project structure
import 'your_goals_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['This Week', 'This Month', 'All Time'];

  // English comment: Helper method to navigate to the goals list with the current filter
  void _navigateToGoals(String filter) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => YourGoalsScreen(filter: filter)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    // English comment: Calculate big circle percentage based on selection
    double periodPercent = habitProvider.getProgressByPeriod(_selectedPeriod);

    // English comment: Filter the goals list based on the selection
    final filteredGoals = habitProvider.goals.where((goal) {
      if (_selectedPeriod == 'All Time') return true;
      if (_selectedPeriod == 'This Week') {
        return goal.period.toLowerCase().contains('week') ||
            goal.period.contains('7');
      }
      return goal.period.toLowerCase().contains('month') ||
          goal.period.contains('30');
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Progress',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Progress Report Header & Dropdown ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress Report',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildDropdown(),
              ],
            ),
            const SizedBox(height: 20),

            // --- Main Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Goals',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _navigateToGoals(_selectedPeriod),
                        child: const Text(
                          'See all',
                          style: TextStyle(color: Color(0xFFF37E31)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- Central Big Progress Circle ---
                  CircularPercentIndicator(
                    radius: 85,
                    lineWidth: 22,
                    percent: periodPercent,
                    progressColor: const Color(0xFFF37E31),
                    backgroundColor: const Color(0xFFF1F1F1),
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      "${(periodPercent * 100).toInt()}%",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF37E31),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Goals Preview List (MAX 3 ITEMS) ---
                  // English comment: .take(3) ensures only the first 3 items are shown
                  ...filteredGoals
                      .take(3)
                      .map(
                        (goal) => _buildGoalPreviewItem(goal, habitProvider),
                      ),

                  if (filteredGoals.length > 3)
                    TextButton(
                      onPressed: () => _navigateToGoals(_selectedPeriod),
                      child: const Text(
                        'View more goals...',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          items: _periods
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedPeriod = value);
              // English comment: Automatically navigate when user changes the period
              _navigateToGoals(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildGoalPreviewItem(HabitModel goal, HabitProvider hp) {
    double p = hp.calculateGoalProgress(goal);
    bool doneToday =
        goal.isCompleted &&
        goal.lastCompleted?.day == DateTime.now().day &&
        goal.lastCompleted?.month == DateTime.now().month &&
        goal.lastCompleted?.year == DateTime.now().year;

    // English comment: Wrap with GestureDetector to enable clicking on each goal item
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetailsScreen(goal: goal),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 18,
              lineWidth: 3,
              percent: p,
              progressColor: const Color(0xFF63E6BE),
              center: Text(
                "${(p * 100).toInt()}%",
                style: const TextStyle(fontSize: 8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.goalTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    hp.getGoalStatusText(goal),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: doneToday
                    ? const Color(0xFFE6FFF5)
                    : const Color(0xFFFFF4E6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                doneToday ? "Today Achieved" : "Pending",
                style: TextStyle(
                  color: doneToday ? Colors.green : Colors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }
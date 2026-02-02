import 'package:flutter/material.dart';
import 'package:habit_tracker/features/auth/providers/auth_provider.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:habit_tracker/habit/screens/add_habit_screen.dart';
import 'package:habit_tracker/habit/models/date.model.dart';
import 'package:habit_tracker/habit/widgets/progress_card.dart';
import 'package:habit_tracker/habit/widgets/todays_habit_section.dart';
import 'package:habit_tracker/habit/widgets/your_goals_section.dart';
import 'package:habit_tracker/theme/colors.dart';
import 'package:provider/provider.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HabitsScreen();
  }
}



class _HabitsScreen extends State<HabitsScreen> {
  // Create an instance of the DateModel utility
  final DateModel date = DateModel();
  

  @override
  Widget build(BuildContext context) {
    // Format the current date for display
    final String dateString = date.getFormattedDate();
    // using watch when theres a change in our data 
    final habitProvider = context.watch<HabitProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // Increased height to accommodate the multi-line title
        toolbarHeight: 80,
        backgroundColor: AppColors.background,
        elevation: 0,
        // Align text to the start (left) to match the UI design
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateString,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                // Retrieve the stored username from the Provider
                final String? userName = userProvider.currentUser?.name;

                return Text(
                  userName != null && userName.isNotEmpty
                      ? 'Hello, $userName '
                      : 'Home',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Adjust based on your AppColors
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            // Display progress overview card
            ProgressCard(
              completedHabits:habitProvider.completedHabits,
              totalHabits:habitProvider.totalHabits,
              progressPercentage:(habitProvider.progressPercentage * 100).toInt(),
            ),
            const SizedBox(height: 20),
            // Section for daily habits list
            TodaysHabitSection(),
            const SizedBox(height: 20),
            // Section for long-term goals
            YourGoalsSection(),
            const SizedBox(height: 100), // Extra space for FAB and BottomBar
          ],
        ),
      ),
      // Position the FAB in the center of the BottomAppBar
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,

      // Primary action button to create new habits
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to open 'Create New Habit' modal goes here
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => AddHabitScreen(),
          );
        },
        backgroundColor: const Color(0xFF71D49D), // Green accent color
        elevation: 4,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}

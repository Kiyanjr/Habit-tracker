import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:habit_tracker/habit/widgets/habit_items.dart';
import 'package:habit_tracker/theme/colors.dart';
import 'package:provider/provider.dart';

class TodaysHabitSection extends StatelessWidget {
  const TodaysHabitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white38.withAlpha(5),
            spreadRadius: 5, // how much the shadow spreads
            blurRadius: 7, // how blurry the shadow is
            offset: Offset(0, 3), // horizontal and vertical offset
          ),
        ],
        color: AppColors.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Today Habit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              // BUTTON
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            itemCount: Provider.of<HabitProvider>(
              context,
              listen: false,
            ).habits.length,
            shrinkWrap: true,//<---- list expands as muvh as it self
            physics: const NeverScrollableScrollPhysics(),  //<---- it helps scrolling in main page dont face a challaneg
            itemBuilder: (context, index) {
              final habit = Provider.of<HabitProvider>(context).habits[index];
              return HabitItem(
                title: habit.title,
                completed: habit.isCompleted,
                onToggle: () {
                  // Direct call to your provider's method
                  Provider.of<HabitProvider>(
                    context,
                    listen: false,
                  ).toggleHabitStatus(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

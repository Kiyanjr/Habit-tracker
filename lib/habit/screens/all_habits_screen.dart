import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/models/date.model.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:habit_tracker/theme/colors.dart';
import 'package:provider/provider.dart';

class AllHabitsScreen extends StatefulWidget {
  const AllHabitsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AllHabitsScreenState();
  }
}

class _AllHabitsScreenState extends State<AllHabitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Your Habit',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: AppColors.accentText,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Calling Calender
          _customCalender(),
          // Calling Habits section
          Expanded(
            child: Consumer<HabitProvider>(
              builder: (context, provider, child) {
                final filtredHabits = provider.habits;
                return ListView.builder(
                  itemCount: filtredHabits.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final habit = filtredHabits[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: habit.isCompleted
                            ? const Color(0xFFE8F5E9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          habit.title,
                          style: TextStyle(
                            color: habit.isCompleted
                              ? const Color(0xFF2E7D32) 
                              : Colors.black87,
                            decoration: habit.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: (){
                              provider.toggleHabitStatus(index);
                              },
                              icon: Icon(
                                habit.isCompleted
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: habit.isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            //  3 dots icon for edit or delete
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                // اینجا منوی حذف و ادیت را باز می‌کنیم
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _customCalender() {
    final DateModel dateLogic = DateModel();
    DateTime selectedDate = DateTime.now();

    // Recalling days from our datemodel method
    List<DateTime> weekDays = List.generate(7, (index) {
      return DateTime.now().subtract(Duration(days: 3 - index));
    });
    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekDays.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          DateTime dayDate = weekDays[index];
          // checking if the current card is selected or not
          bool isSelected =
              dayDate.year == selectedDate.year &&
              dayDate.month == selectedDate.month &&
              dayDate.day == selectedDate.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = dayDate; // updating the date
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFF3E0) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFFCC80)
                      : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${dayDate.day}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFFFF8A65)
                          : Colors.black,
                    ),
                  ),
                  Text(
                    dateLogic.getMonthName(dayDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? const Color(0xFFFF8A65) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/models/habit_model.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:habit_tracker/theme/colors.dart';
import 'package:provider/provider.dart';

class HabitEditDialog extends StatefulWidget {
  const HabitEditDialog({super.key, required this.habit});
  final HabitModel habit;

  @override
  State<HabitEditDialog> createState() => _HabitEditDialogState();
}

class _HabitEditDialogState extends State<HabitEditDialog> {
  late TextEditingController _habitEditing;
  late TextEditingController _goalEditing;
  late String selectedPeriod;
  late String selectedHabitType;

  // Data lists for the dropdown menus
  final List<String> itemsOfPeriod = [
    '1 Week (7 Days)',
    '1 Month (30 Days)',
    '3 Months (90 Days)',
  ];

  final List<String> itemsOfHabitType = ['Everyday', 'Weekdays', 'Custom'];

  @override
  void initState() {
    super.initState();
    //  Giving current values to the controllers
    _habitEditing = TextEditingController(text: widget.habit.title);
    _goalEditing = TextEditingController(text: widget.habit.goalTitle);
    selectedPeriod = widget.habit.period;
    selectedHabitType = widget.habit.habitType;
  }

  @override
  void dispose() {
    _habitEditing.dispose();
    _goalEditing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    return AlertDialog(
      backgroundColor: Colors.white,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Edit Habit', style: TextStyle(fontSize: 18)),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: AppColors.primaryGradientEnd),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width, // Widt size
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Divider(color: AppColors.primaryGradientEnd, thickness: 2),
              const SizedBox(height: 3),
              const Text(
                'Your Goal',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  border: Border.all(color: Colors.black45, width: 1),
                ),
                child: TextField(
                  controller: _goalEditing,
                  decoration: InputDecoration(
                    hintText: provider.goals.toString(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                'Habit Name',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  border: Border.all(color: Colors.black45, width: 1),
                ),
                child: TextField(
                  controller: _habitEditing,
                  decoration: InputDecoration(
                    hintText: provider.habits.toString(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Divider(color: Colors.black26),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Period :',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedPeriod,
                      items: itemsOfPeriod
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPeriod = value!;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Habit Type : ',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedHabitType,
                      items: itemsOfHabitType
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHabitType = value!;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  //----------Getting Changed Goals Habits---
                  String newTitle = _habitEditing.text;
                  String newGoal = _goalEditing.text;

                  final updatedModel = HabitModel(
                    title: newTitle,
                    goalTitle: newGoal,
                    habitType: selectedHabitType,
                    period: selectedPeriod,
                  );
                  Provider.of<HabitProvider>(
                    context,
                    listen: false,
                  ).updateHabitGoal(updatedModel, widget.habit.title);

                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 229, 145, 77),
                        AppColors.primaryGradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

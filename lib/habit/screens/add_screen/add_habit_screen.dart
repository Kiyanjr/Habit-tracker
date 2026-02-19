import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/models/habit_model.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:habit_tracker/habit/screens/add_screen/done_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddHabitScreen();
  }
}

class _AddHabitScreen extends State<AddHabitScreen> {
  // Text controllers to capture and manage user input
  final TextEditingController _goalInput = TextEditingController();
  final TextEditingController _habitInput = TextEditingController();

  // Default values for dropdown selections
  String selectedPeriod = '1 Week (7 Days)';
  String selectedHabitType = 'Everyday';

  // Data lists for the dropdown menus
  final List<String> itemsOfPeriod = [
    '1 Week (7 Days)',
    '1 Month (30 Days)',
    '3 Months (90 Days)',
  ];

  final List<String> itemsOfHabitType = [
    'Everyday', 
    'Weekdays', 
    'Custom',
    ];

  @override
  void dispose() {
    _habitInput.dispose();
    _goalInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logic to validate inputs and save the new habit
    void _createHabit() {
      // Basic validation: ensure text fields are not empty or just whitespace
      if (_habitInput.text.trim().isEmpty || _goalInput.text.trim().isEmpty) {
        ScaffoldMessenger.of(context,)
        .showSnackBar(const SnackBar(content: Text('All fields must be filled')));
        return;
      }

      // Create a new Habit object using the Model
      final newHabit = HabitModel(
        id: const Uuid().v4(), // Generate a unique ID
        title: _habitInput.text.trim(),
        goalTitle: _goalInput.text.trim(),
        period: selectedPeriod,
        habitType: selectedHabitType,
        isCompleted: false,
      );

      try {
        // Add the new habit to the global state via Provider
       final habitProvider=Provider.of<HabitProvider>(context,listen: false);

       habitProvider.addHabit(newHabit);
       habitProvider.addGoal(newHabit);
        
        // Navigate to the success/done screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoneScreen()),
        );
      } catch (e) {
        // Error handling for state updates
        print('add habit page has error: $e');
      }
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          // Dynamic bottom padding to adjust when the keyboard appears
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title and Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create New Habit Goal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Goal Input Section
            const Text(
              'Your Goal',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _goalInput,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Habit Name Input Section
            const Text(
              'Habit Name',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _habitInput,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Period Selection Dropdown
            Row(
              children: [
                const Text(
                  'Period',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedPeriod,
                    items: itemsOfPeriod
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPeriod = value!; //not null
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
            
            // Habit Type Selection Dropdown
            Row(
              children: [
                const Text(
                  'Habit Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedHabitType,
                    items: itemsOfHabitType
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Action Button: Create Habit
            SizedBox(
              width: double.infinity, // Occupies full available width
              height: 50,
              child: ElevatedButton(
                onPressed: _createHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7E5F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Create New',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
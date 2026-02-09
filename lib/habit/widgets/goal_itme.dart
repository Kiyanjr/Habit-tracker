
import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/models/habit_model.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:habit_tracker/habit/widgets/delete_action_dialog.dart';
import 'package:habit_tracker/habit/widgets/goal_delete_action_dialog.dart';
import 'package:habit_tracker/theme/colors.dart';
import 'package:provider/provider.dart';


class GoalItem extends StatelessWidget {
  /// We now require the full HabitModel and the calculated progress
  const GoalItem({
    super.key,
    required this.habit,
    required this.progress,
    required this.statusText,
  });

  final HabitModel habit;
  final double progress; // Calculated in provider
  final String statusText; // e.g. "1 from 7 days target"

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Adding a subtle shadow to match Figma design
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for Title and the three-dot menu icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                habit.goalTitle, // Using goal from model
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
             TextButton(
              onPressed: (){
                _showActionMenu(context, habit);
              }, 
              child:Icon(Icons.more_vert),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Dynamic Progress Bar with Rounded Corners
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 8.0,
              value: progress, // Dynamic value from Provider
              backgroundColor: Colors.grey.shade100,
              color: AppColors.primaryGradientEnd,
            ),
          ),
          const SizedBox(height: 12),
          
          // Subtitle for progress details
          Text(
            statusText,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          
          // Habit Type (e.g., Everyday) in orange
          Text(
            habit.habitType,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // -----Action menu for  three dot icons for our Buttons
 void _showActionMenu(BuildContext context,HabitModel habit){
  showModalBottomSheet(
    context:context,
    shape: BeveledRectangleBorder(borderRadius:BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
      padding:const  EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //---------------------EDIT-------------
          ListTile(
            leading: const Icon(Icons.edit,color: AppColors.accentText),
            title: const Text('Edit'),
            onTap: (){

              /// EDIT FUNCTION
            },
            ),
          const Divider(),

          //------------Delete----------------
          ListTile(
           leading: const Icon(Icons.delete,color: AppColors.accentText),
           title: const Text("Delete"),
           onTap: () {
               showDeleteConfirmation(context, habit);
           },
          ),
        ],
      ),
      );
    },
    );
  }
  void showDeleteConfirmation(BuildContext context,HabitModel habit){
    final provider=Provider.of<HabitProvider>(context,listen:false);
    showDialog(
      context: context,
     builder:(context)=>GoalDeleteActionDialog(
      goalTitle:habit.goalTitle,
     onDeleteConfirmed: (){
      provider.deleteHabit(habit);
     },
      ),
     );

  }
}
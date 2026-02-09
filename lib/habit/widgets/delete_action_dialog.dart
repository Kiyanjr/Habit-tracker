import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/screens/habits_screen.dart';
import 'package:habit_tracker/theme/colors.dart';

class DeleteActionDialog extends StatefulWidget {
  const DeleteActionDialog({
    super.key,
    required this.habitTitle,
    required this.onDeleteConfirmed,
  });
  final String habitTitle;
  final VoidCallback onDeleteConfirmed;
  @override
  State<DeleteActionDialog> createState() {
    return _DeleteActionDialog();
  }
}

class _DeleteActionDialog extends State<DeleteActionDialog> {
  bool isDeleted = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isDeleted
              ? Image.asset('assets/logo/delete_success.png')
              : Image.asset('assets/logo/delete.png'),
          const SizedBox(height: 16),
          Text(
            isDeleted ? 'Deleted Successfully!' : 'Are you sure?',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isDeleted
                ? "The habit '${widget.habitTitle}' has been removed."
                : "Do you really want to delete '${widget.habitTitle}'?",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          //Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!isDeleted) {
                  widget.onDeleteConfirmed();
                  setState(() {
                    isDeleted = true;
                  });
                } else if (isDeleted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HabitsScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGradientEnd,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                isDeleted ? 'OK' : 'Yes Delete it',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

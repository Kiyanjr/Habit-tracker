
import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/provider/habit_provider.dart';
import 'package:habit_tracker/habit/widgets/goal_itme.dart';
import 'package:habit_tracker/theme/colors.dart';
import 'package:provider/provider.dart';

  // displays the goal part of column part of home screen 
class YourGoalsSection  extends StatelessWidget{

  const YourGoalsSection({super.key});
  @override
  Widget build(BuildContext context) {
      final habitProvider=Provider.of<HabitProvider>(context);
     final goallist=habitProvider.goals;
    return Container(
      margin:EdgeInsets.symmetric(horizontal: 20) ,
      padding:EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          'Your Goal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
         SizedBox(height: 16),
         ListView.builder(
          itemCount:goallist.length,
          shrinkWrap: true,//<---- list expands as muvh as it self
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context,index){
             final goal=goallist[index];
            return GoalItem(
              habit:goal, 
              progress:habitProvider.calculateGoalProgress(goal), 
              statusText:habitProvider.getGoalStatusText(goal) ,
              );
          }
          ),
        ],
      ),
    );
  }

}
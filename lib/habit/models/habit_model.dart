import 'package:uuid/uuid.dart';

const uuid = Uuid();

class HabitModel {
  final String id;
  final String title;
  final String goalTitle;
  final  String period;
  final  String habitType;
  final bool isCompleted;

  HabitModel({ 
     String? id,
    required this.title,
    required this.goalTitle,
    required this.habitType,
    required this.period,
    this.isCompleted = false,
    
    }) : id = id ?? uuid.v4();
    

     //      two codes of down there is used to store in memmory
   Map<String,dynamic>toMap(){
    return {
      'id':id,
      'title':title,
      'goalTitle':goalTitle,
      'habitType':habitType,
      'period':period,
      'isCompleted':isCompleted,
    };
   }
     // call back the memmory to the map
   factory HabitModel.fromMap(Map<String,dynamic> map){
      return HabitModel(
        id: map['id'],
        title: map['title'],
        goalTitle:map['goalTitle'],
        habitType:map['habitType'],
        period: map['period'],
        isCompleted: map['isCompleted'],
     );
   }
   

  HabitModel copyWith({
    String? id,
    String? title,
    String? goalTitle,
    String? period,
    String?  habitType ,
    bool? isCompleted,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      goalTitle: goalTitle ?? this.goalTitle,
      period: period ??  this.period,
      habitType:habitType?? this.habitType,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

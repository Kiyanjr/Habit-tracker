import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/screens/habits_screen.dart';
import 'package:habit_tracker/habit/screens/progress_screen.dart';
import 'package:habit_tracker/habit/screens/settings_screen.dart';
import 'package:habit_tracker/theme/colors.dart';
  

   ////----------------------THIS CLASS IS CALLED IN SPALSH_SCREEN.DART----------
class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});
  @override
  State<BottomNavWrapper> createState() {
    return _BottomNavWrapper();
  }
}

class _BottomNavWrapper extends State<BottomNavWrapper> {
  int _selectedIndex = 0;
  static const TextStyle style = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.deepOrangeAccent,
  );
  static const List<Widget> _page = <Widget>[
    HabitsScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];
  void _onItemTapped(int Index) {
    setState(() {
      _selectedIndex = Index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _page,
      ), //<-------Keep pages but show whats is selected
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child:BottomNavigationBar(
          type:BottomNavigationBarType.fixed,//<----wont let the icons move
          backgroundColor: Colors.white24,
          currentIndex:_selectedIndex,
          selectedItemColor: const Color(0xFFE5914D),
          unselectedItemColor:Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap:_onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

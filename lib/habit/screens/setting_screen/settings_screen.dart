import 'package:flutter/material.dart';
import 'package:habit_tracker/habit/screens/setting_screen/detail_setting_screen.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Setting', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSettingItem(
                context, 
                title: 'Account', 
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountDetailScreen()),
                  );
                },
              ),
              _buildSettingItem(context, title: 'Term and Condition'),
              _buildSettingItem(context, title: 'Policy'),
              _buildSettingItem(context, title: 'About App', isLast: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {required String title, VoidCallback? onTap, bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          onTap: onTap,
        ),
        if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
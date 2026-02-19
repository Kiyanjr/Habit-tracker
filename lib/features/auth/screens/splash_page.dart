import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/features/auth/providers/auth_provider.dart';
import 'package:habit_tracker/features/auth/screens/login_screen.dart'; 
import 'package:habit_tracker/habit/screens/bottom_nav_wrapper.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _animationController.forward();

    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Timer(const Duration(seconds: 3), () async {
      if (mounted) {
        // 1. Check Firebase Auth state
        final User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // 2. Sync Firebase user data with our UserProvider and SharedPreferences
          // English comment: Use await to ensure data is saved before moving to the next screen
          await Provider.of<UserProvider>(context, listen: false).setUserNameAndEmail(
            name: user.displayName ?? "User",
            email: user.email ?? "",
          );

          if (!mounted) return;

          // 3. Navigate to Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavWrapper(),
            ),
          );
        } else {
          // 4. No user found, go to Login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation,
        child: const Center(
          child: Text(
            'Welcome',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
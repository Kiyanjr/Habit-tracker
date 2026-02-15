import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/features/auth/screens/login_screen.dart';
import 'package:habit_tracker/features/auth/providers/auth_provider.dart';
import 'package:habit_tracker/habit/screens/bottom_nav_wrapper.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Controller manages the animation timing
  late AnimationController _animationController;
  // Animation defines the value change (opacity from 0.0 to 1.0)
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize the AnimationController
    // The animation will take 2 seconds to complete (fade in duration)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // 2. Define tween animation
    // Creates a linear interpolation from 0 (transparent) to 1 (opaque)
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    // 3. Start the animation
    _animationController.forward();

    // 4. Schedule navigation to the next screen
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    // Important: Dispose the controller when the widget is removed to prevent memory leaks
    _animationController.dispose();
    super.dispose();
  }

  // Method to handle navigation after a delay
  void _navigateToNextScreen() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // 1. Check if a user is already signed in via Firebase
        final User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // 2. If user exists, sync basic info to Provider before navigating
          // This ensures the Home screen has the name/email ready
          Provider.of<UserProvider>(context, listen: false).setUserNameAndEmail(
            name: user.displayName ?? "User",
            email: user.email ?? "",
          );

          // 3. Navigate directly to HabitsScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavWrapper(),
            ),
          );
        } else {
          // 4. If no user is signed in, navigate to LoginScreen
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
      // White background as requested
      backgroundColor: Colors.white,
      // FadeTransition applies the opacity animation to its child
      body: FadeTransition(
        opacity: _animation,
        // The 'Center' widget places the text in the middle of the screen
        child: const Center(
          child: Text(
            'Welcome', // English Text
            style: TextStyle(
              color: Colors.orange, // Orange text color
              fontSize: 40.0, // Large font size for title
              fontWeight: FontWeight.bold, // Bold text
              letterSpacing: 1.5, // Slightly spaced letters for better look
            ),
          ),
        ),
      ),
    );
  }
}

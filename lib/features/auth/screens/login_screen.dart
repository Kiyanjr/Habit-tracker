import 'package:flutter/material.dart';
import 'package:habit_tracker/features/auth/providers/auth_provider.dart';

import 'package:habit_tracker/features/auth/screens/sign_up_screen.dart';
import 'package:habit_tracker/habit/screens/bottom_nav_wrapper.dart'; // English comment: Usually better than directly going to HabitsScreen
import 'package:habit_tracker/theme/colors.dart';
import 'package:habit_tracker/features/auth/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final TextEditingController _nameInput = TextEditingController();
  
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameInput.dispose();
    _emailInput.dispose();
    _passwordInput.dispose();
    super.dispose();
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // English comment: Use UserProvider to manage the state
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        title: const Text(
          'Log In',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(_emailInput, '.....@gmail.com'),
              const SizedBox(height: 15),
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(_passwordInput, '', isObscure: true),
              const SizedBox(height: 15),
              _buildLabel('Name'),
              const SizedBox(height: 8),
              _buildTextField(_nameInput, 'Your Name'),

              const SizedBox(height: 35),
              
              // --- Login Button ---
              GestureDetector(
                onTap: () async {
                  final email = _emailInput.text.trim();
                  final password = _passwordInput.text.trim();
                  final name = _nameInput.text.trim();

                  if (email.isEmpty || password.isEmpty || name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );

                  final result = await _authService.logIn(email, name, password);

                  if (!mounted) return;
                  Navigator.pop(context); // Close loading dialog

                  if (result == null) {
                    // English comment: Update the provider (it handles SharedPreferences internally)
                    await userProvider.setUserNameAndEmail(name: name, email: email);

                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomNavWrapper()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  }
                },
                child: _buildLoginButton(),
              ),

              const SizedBox(height: 40),
              
              TextButton(
                onPressed: () => _navigateToSignUp(context),
                child: const Text(
                  'Don\'t have an account? Click here.',
                  style: TextStyle(
                    color: AppColors.accentText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets to keep code clean ---
  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isObscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Text(
        'Log In',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.background),
      ),
    );
  }
}
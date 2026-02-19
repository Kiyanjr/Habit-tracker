import 'package:flutter/material.dart';
import 'package:habit_tracker/features/auth/providers/auth_provider.dart';
import 'package:habit_tracker/features/auth/screens/sign_up_screen.dart';
import 'package:habit_tracker/habit/screens/home_screen/habits_screen.dart';
import 'package:habit_tracker/theme/colors.dart';
import 'package:habit_tracker/features/auth/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final TextEditingController _nameInput = TextEditingController();
  //auth
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
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        title: Text(
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
              // Email TextFiled
              const Text(
                'Email',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              //box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: TextField(
                  controller: _emailInput,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ), //<---user input till the border of box
                    hintText: '.....@gmail.com',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              //Password TextField
              const Text(
                'Password',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: TextField(
                  obscureText: true, //<--hiding the user input
                  controller: _passwordInput,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ), //<---user input till the border of box
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              //name
              const Text(
                'Name',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: TextField(
                  obscureText: false, //<--hiding the user input
                  controller: _nameInput,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ), //<---user input till the border of box
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 35),
              // login buttom
              GestureDetector(
                onTap: () async {
                  final email = _emailInput.text.trim();
                  final password = _passwordInput.text.trim();
                  final name = _nameInput.text.trim();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()),
                  );
                  final result = await _authService.logIn(
                    email,
                    name,
                    password,
                  );
                  Navigator.pop(context);
                  // close loading
                  if (result == null) {
                    //  saving user inputs
                    final prefs=await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', true);
                    await prefs.setString('userName', name);
                    await prefs.setString('userEmail', email);
                    //upadting provider
                    userProvider.setUserNameAndEmail(name: name, email: email);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HabitsScreen()),
                    );
                  } else {
                    // ERROR
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(result)));
                  }
                },
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGradientStart,
                        AppColors.primaryGradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              // sing up
              TextButton(
                onPressed: () {
                  _navigateToSignUp(context);
                },
                child: Text(
                  'Dont have an accont?? click here.',
                  style: TextStyle(
                    color: AppColors.accentText,
                    fontSize: 20,
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
}

import 'package:flutter/material.dart';
import 'package:habit_tracker/features/auth/screens/login_screen.dart';
import 'package:habit_tracker/features/auth/providers/auth_provider.dart';
import 'package:habit_tracker/features/auth/services/auth_service.dart';
import 'package:habit_tracker/theme/colors.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() {
    return _SignUpScreen();
  }
}

class _SignUpScreen extends State<SignUpScreen> {
  final TextEditingController _nameParamater = TextEditingController();
  final TextEditingController _emailParamater = TextEditingController();
  final TextEditingController _passwordParamater = TextEditingController();
  final TextEditingController _reapeatPasswordParamater = TextEditingController();

  //auth
  final AuthService _authService = AuthService();

  void _navigateToLogIn(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void dispose() {
    _reapeatPasswordParamater.dispose();
    _nameParamater.dispose();
    _emailParamater.dispose();
    _passwordParamater.dispose();
    super.dispose();
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
        title: Row(
          children: [
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Expanded(
              child: Text(
                'Log In',
                textAlign:TextAlign.right,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _navigateToLogIn(context);
              },
              icon: const Icon(Icons.arrow_forward),
              color: AppColors.primaryGradientEnd,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              //Name field
              const Text(
                'Name',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              //nameBox
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: TextField(
                  controller: _nameParamater,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //Email box
              const Text(
                'Email',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: TextField(
                  controller: _emailParamater,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: 10),

              //Password input
              const Text(
                'Password',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: TextField(
                  obscureText: true,
                  controller: _passwordParamater,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),

              //Reapeat Password input
              const Text(
                'Repeat_Password',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: TextField(
                  obscureText: true,
                  controller: _reapeatPasswordParamater,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),

              //Sign up button
              const SizedBox(height: 35),

              GestureDetector(
                onTap: () async {
                  final name = _nameParamater.text.trim();
                  final email = _emailParamater.text.trim();
                  final pass = _passwordParamater.text.trim();
                  final repeatPass = _reapeatPasswordParamater.text.trim();

                  if (pass != repeatPass) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()),
                  );

                  final result = await _authService.singUp(
                    email,
                    pass,
                    name,
                    repeatPass,
                  );

                  Navigator.pop(context); // close loading

                  if (result == null) {
                    // without any error we replace it
                    userProvider.setUserNameAndEmail(name: name, email: email);
                    // SUCCESS
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else {
                    // ERROR
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(result)));
                  }
                },
                child: Container(
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
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
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
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

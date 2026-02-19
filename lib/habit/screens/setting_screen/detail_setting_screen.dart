import 'package:flutter/material.dart';
import 'package:habit_tracker/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({super.key});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _passwordController = TextEditingController(text: "********");

  @override
  void initState() {
    super.initState();
    // English comment: Fetch the current user data from Provider to fill the TextFields initially
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: userProvider.currentUser?.name ?? "");
    _emailController = TextEditingController(text: userProvider.currentUser?.email ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // English comment: Listen to changes in UserProvider
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Info',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            // --- Name Field ---
            _buildInputField(
              label: "Name", 
              controller: _nameController, 
              suffixIcon: Icons.person_outline
            ),
            const SizedBox(height: 20),
            
            // --- Email Field ---
            _buildInputField(
              label: "Email", 
              controller: _emailController, 
              suffixIcon: Icons.email_outlined
            ),
            const SizedBox(height: 20),
            
            // --- Password Field (Static UI for now) ---
            _buildInputField(
              label: "Password", 
              controller: _passwordController, 
              isPassword: true, 
              suffixIcon: Icons.lock_outline
            ),
            
            const SizedBox(height: 50),
            
            // --- Update Button ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  // English comment: Update the Provider and Local Storage with new values
                  if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
                    await userProvider.setUserNameAndEmail(
                      name: _nameController.text,
                      email: _emailController.text,
                    );
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Account information updated!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF37E31), // Brand Orange
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text(
                  'Update Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label, 
    required TextEditingController controller, 
    bool isPassword = false, 
    IconData? suffixIcon
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            suffixIcon: Icon(suffixIcon, size: 20, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFF37E31), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
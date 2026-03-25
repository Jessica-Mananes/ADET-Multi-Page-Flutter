import 'package:flutter/material.dart';
import 'data.dart';
import 'user_profile.dart';
import 'home_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {

  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _bioCtrl   = TextEditingController();

  void _save() {
    if (_formKey.currentState!.validate()) {
      currentUser = UserProfile(
        username:   _nameCtrl.text.trim(),
        bio:        _bioCtrl.text.trim(),
        joinedDate: DateTime.now(),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,

      appBar: AppBar(
        backgroundColor: kNavy,
        foregroundColor: kWhite,
        elevation: 0,
        title: const Text(
          'Create Your Profile',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EDD6),
                      shape: BoxShape.circle,
                      border: Border.all(color: kGold, width: 2),
                    ),
                    child: const Icon(Icons.person, size: 44, color: kGold),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Welcome to TOL!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: kNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Set up your profile to get started.',
                    style: TextStyle(fontSize: 13, color: kGrey),
                  ),
                  const SizedBox(height: 32),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kNavy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. juan_dela_cruz',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: kCream,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: kBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: kBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: kGold, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Short Bio (optional)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kNavy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _bioCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tell the community about yourself...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: kCream,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: kBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: kBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: kGold, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kNavy,
                        foregroundColor: kWhite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      child: const Text('SAVE AND CONTINUE'),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data.dart';
import 'browse_screen.dart';
import 'donate_screen.dart';
import 'profile_screen.dart';
import 'setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Go to a screen and refresh when we come back
  void _go(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    setState(() {});
  }

  void _onBrowse() {
    if (currentUser == null) {
      _go(const SetupScreen());
    } else {
      _go(const BrowseScreen());
    }
  }

  void _onDonate() {
    if (currentUser == null) {
      _go(const SetupScreen());
    } else {
      _go(const DonateScreen());
    }
  }

  void _onProfile() {
    if (currentUser == null) {
      _go(const SetupScreen());
    } else {
      _go(const ProfileScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,

      // ── AppBar ──
      appBar: AppBar(
        backgroundColor: kNavy,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'TOL',
          style: GoogleFonts.playfairDisplay(
            color: kWhite,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 3,
          ),
        ),
        actions: [
          // Profile icon button
          IconButton(
            icon: const Icon(Icons.person_outline, color: kWhite),
            onPressed: _onProfile,
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ── Body ──
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            // Max width so it looks good on wide screens
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Logo icon
                Container(
                  width: 1000,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EDD6),
                    shape: BoxShape.circle,
                    border: Border.all(color: kGold, width: 2),
                  ),
                 child: ClipOval(
                  child: Image.asset(
                    'assets/images/TOL.png',
                    width: 500,
                    height: 400,
                  ),
                ),
                ),
                const SizedBox(height: 24),

                // App title
                Text(
                  'TAKE ONE,',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
                Text(
                  'LEAVE ONE',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: kGold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                const Text(
                  'A community sharing platform. \n Give only what you can, and take only what you need.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: kGrey,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 24),

                // Rule reminder box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EDD6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kGold),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: kGold, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You must donate at least 1 item before you can take something.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A5C1E),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Browse button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _onBrowse,
                    icon: const Icon(Icons.search),
                    label: const Text('BROWSE ITEMS'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kNavy,
                      side: const BorderSide(color: kGold, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Donate button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _onDonate,
                    icon: const Icon(Icons.add_box_outlined),
                    label: const Text('DONATE AN ITEM'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: kWhite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Profile button
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _onProfile,
                    icon: const Icon(Icons.person_outline),
                    label: Text(
                      currentUser == null ? 'SET UP YOUR PROFILE' : 'VIEW MY PROFILE',
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: kGrey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
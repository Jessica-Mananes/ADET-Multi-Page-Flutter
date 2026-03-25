import 'package:flutter/material.dart';
import 'data.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'setup_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void _editProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SetupScreen()),
    );
    setState(() {});
  }

  void _resetProfile() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reset Profile?',
          style: TextStyle(fontWeight: FontWeight.w700, color: kNavy),
        ),
        content: const Text(
          'This will clear your profile and all your history.',
          style: TextStyle(fontSize: 13, color: kGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              currentUser = null;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: kWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser!;

    return Scaffold(
      backgroundColor: kCream,

      // ── AppBar ──
      appBar: AppBar(
        backgroundColor: kNavy,
        foregroundColor: kWhite,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editProfile,
            tooltip: 'Edit Profile',
          ),
        ],
      ),

      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 560),

          // ── SingleChildScrollView ──
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                // ── Profile card ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder),
                  ),
                  child: Column(
                    children: [

                      // Avatar with first letter
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EDD6),
                          shape: BoxShape.circle,
                          border: Border.all(color: kGold, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            user.username[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: kGold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Username
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: kNavy,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Bio
                      if (user.bio.isNotEmpty)
                        Text(
                          user.bio,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: kGrey,
                            height: 1.5,
                          ),
                        ),
                      const SizedBox(height: 4),

                      // Join date
                      Text(
                        'Joined ${_formatDate(user.joinedDate)}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // ── Stats row (only donated and taken) ──
                      Row(
                        children: [
                          Expanded(
                            child: _statBox(
                              icon: '📦',
                              label: 'Donated',
                              value: '${user.donatedItems.length}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statBox(
                              icon: '✋',
                              label: 'Taken',
                              value: '${user.takenItems.length}',
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Donate gate status ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: user.canTakeItem
                      ? const Color(0xFFD8F3DC)
                      : const Color(0xFFF5EDD6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: user.canTakeItem
                        ? const Color(0xFF2D6A4F)
                        : kGold,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        user.canTakeItem ? '✅' : '⏳',
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.canTakeItem
                                ? 'You can take items!'
                                : 'Donate first to unlock taking',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: user.canTakeItem
                                  ? const Color(0xFF2D6A4F)
                                  : const Color(0xFF7A5C1E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.canTakeItem
                                ? 'Thank you for contributing to the community.'
                                : 'Donate at least 1 item first.',
                              style: TextStyle(
                                fontSize: 11,
                                color: user.canTakeItem
                                  ? const Color(0xFF2D6A4F)
                                  : const Color(0xFF7A5C1E),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Menu options ──
                _menuItem(
                  icon: Icons.history,
                  label: 'My History',
                  subtitle: 'See your donated and taken items',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                ),
                const SizedBox(height: 10),

                _menuItem(
                  icon: Icons.edit_outlined,
                  label: 'Edit Profile',
                  subtitle: 'Update your username and bio',
                  onTap: _editProfile,
                ),
                const SizedBox(height: 10),

                _menuItem(
                  icon: Icons.delete_outline,
                  label: 'Reset Profile',
                  subtitle: 'Clear all your data and start over',
                  onTap: _resetProfile,
                  isRed: true,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statBox({
    required String icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: kCream,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    bool isRed = false,
  }) {
    Color color = isRed ? Colors.red : kNavy;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
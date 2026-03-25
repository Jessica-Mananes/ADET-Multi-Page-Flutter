import 'dart:convert';
import 'package:flutter/material.dart';
import 'data.dart';
import 'item.dart';
import 'donate_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {

  void _takeItem(Item item) {
    // ── GATE: user must have donated first ──
    if (currentUser == null || !currentUser!.canTakeItem) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Donate First!',
            style: TextStyle(fontWeight: FontWeight.w700, color: kNavy),
          ),
          content: const Text(
            'You need to donate at least 1 item before you can take something.\n\nThis is the spirit of TOL — give before you receive!',
            style: TextStyle(fontSize: 13, color: kGrey, height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Not now', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DonateScreen()),
                ).then((_) => setState(() {}));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavy,
                foregroundColor: kWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Donate Now'),
            ),
          ],
        ),
      );
      return;
    }

    // ── User is allowed to take ──
    setState(() {
      item.status = 'taken';
      item.takenBy = currentUser!.username;
      currentUser!.takenItems.add(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item taken! Enjoy it 💛'),
        backgroundColor: kNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int availableCount = globalItems.where((i) => i.status == 'available').length;

    return Scaffold(
      backgroundColor: kCream,

      // ── AppBar ──
      appBar: AppBar(
        backgroundColor: kNavy,
        foregroundColor: kWhite,
        elevation: 0,
        title: const Text(
          'Browse Items',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kGold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$availableCount available',
              style: const TextStyle(
                color: kNavy,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),

      // ── Donate FAB ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DonateScreen()),
        ).then((_) => setState(() {})),
        backgroundColor: kNavy,
        foregroundColor: kWhite,
        icon: const Icon(Icons.add),
        label: const Text(
          'Donate',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),

          // ── SingleChildScrollView ──
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: globalItems.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        Text('📭', style: TextStyle(fontSize: 56)),
                        SizedBox(height: 16),
                        Text(
                          'No items yet.\nBe the first to donate something!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              // ── Column of cards ──
              : Column(
                  children: globalItems.map((item) {
                    return _ItemCard(
                      item: item,
                      onTake: () => _takeItem(item),
                    );
                  }).toList(),
                ),
          ),
        ),
      ),
    );
  }
}

// ── Item Card Widget ──
class _ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTake;

  const _ItemCard({required this.item, required this.onTake});

  String get emoji {
    switch (item.category) {
      case 'Appliances':      return '🍳';
      case 'Books':           return '📚';
      case 'Clothing':        return '👕';
      case 'Furniture':       return '🪑';
      case 'Toys':            return '🧸';
      case 'School Supplies': return '✏️';
      default:                return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTaken = item.status == 'taken';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Item image ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: item.imageUrl != null
              ? Image.memory(
                  base64Decode(item.imageUrl!),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: double.infinity,
                  height: 180,
                  color: const Color(0xFFF5EDD6),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 60)),
                  ),
                ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Status and category row ──
                Row(
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isTaken
                          ? const Color(0xFFFFEBEE)
                          : const Color(0xFFD8F3DC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isTaken ? '🚫  Taken' : '✅  Available',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isTaken
                            ? const Color(0xFFC0392B)
                            : const Color(0xFF2D6A4F),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EDD6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$emoji  ${item.category}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: kGold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Item name ──
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kNavy,
                  ),
                ),
                const SizedBox(height: 6),

                // ── Description ──
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: kGrey,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 14),

                // ── Divider ──
                const Divider(color: kBorder, height: 1),
                const SizedBox(height: 12),

                // ── Footer row: donor + button ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // Donor info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DONATED BY',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.donor,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: kGrey,
                          ),
                        ),
                        if (isTaken && item.takenBy != null)
                          Text(
                            'Taken by: ${item.takenBy}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFC0392B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),

                    // ── Take button ──
                    ElevatedButton(
                      onPressed: isTaken ? null : onTake,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kNavy,
                        foregroundColor: kWhite,
                        disabledBackgroundColor: const Color(0xFFFFEBEE),
                        disabledForegroundColor: const Color(0xFFC0392B),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isTaken ? 'Already Taken' : '✋  Take This',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
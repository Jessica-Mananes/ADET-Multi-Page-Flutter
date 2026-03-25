import 'dart:convert';
import 'package:flutter/material.dart';
import 'data.dart';
import 'item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser!;

    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        backgroundColor: kNavy,
        foregroundColor: kWhite,
        elevation: 0,
        title: const Text(
          'My History',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kGold,
          labelColor: kWhite,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: [
            Tab(text: 'Donated (${user.donatedItems.length})'),
            Tab(text: 'Taken (${user.takenItems.length})'),
          ],
        ),
      ),

      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildList(user.donatedItems, isDonated: true),
              _buildList(user.takenItems, isDonated: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<Item> items, {required bool isDonated}) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isDonated ? '📦' : '✋', style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            Text(
              isDonated
                ? 'You have not donated anything yet.'
                : 'You have not taken anything yet.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.6),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: items.map((item) => _HistoryCard(
          item: item,
          isDonated: isDonated,
        )).toList(),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Item item;
  final bool isDonated;

  const _HistoryCard({required this.item, required this.isDonated});

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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item.imageUrl != null
                ? Image.memory(
                    base64Decode(item.imageUrl!),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 64,
                    height: 64,
                    color: const Color(0xFFF5EDD6),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: kNavy,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDonated
                            ? const Color(0xFFD8F3DC)
                            : const Color(0xFFF5EDD6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isDonated ? 'Donated' : 'Taken',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isDonated
                              ? const Color(0xFF2D6A4F)
                              : const Color(0xFF7A5C1E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kGrey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$emoji  ${item.category}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'item.dart';
import 'user_profile.dart';

const Color kNavy  = Color(0xFF1D3557);
const Color kGold  = Color(0xFFB8963E);
const Color kCream = Color(0xFFFDFAF4);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGrey  = Color(0xFF4A5568);
const Color kBorder = Color(0xFFE8DFC8);

UserProfile? currentUser;

List<Item> globalItems = [
  Item(
    id: 1,
    name: 'Pan',
    description: 'National brand, Barely used.',
    category: 'Appliances',
    donor: 'Maria',
  ),
  Item(
    id: 2,
    name: 'Story Books (set of 5)',
    description: 'Colorful picture books for ages 3 to 7. Great condition.',
    category: 'Books',
    donor: 'The Cruz Family',
  ),
  Item(
    id: 3,
    name: 'Blue School Backpack',
    description: 'Large bag with padded straps. Very sturdy. Good for Grade 4 to 6.',
    category: 'School Supplies',
    donor: 'Anonymous',
  ),
  Item(
    id: 4,
    name: 'Stuffed Teddy Bear',
    description: 'Large soft bear. Machine washable. My child outgrew it.',
    category: 'Toys',
    donor: 'Lena',
    status: 'taken',
  ),
];
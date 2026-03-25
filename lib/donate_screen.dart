import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'data.dart';
import 'item.dart';
import 'browse_screen.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {

  final _formKey      = GlobalKey<FormState>();
  final _nameCtrl     = TextEditingController();
  final _descCtrl     = TextEditingController();
  final _picker       = ImagePicker();

  String  _category   = 'Appliances';
  String? _imageBase64;
  bool    _submitted  = false;

  final List<String> _categories = [
    'Appliances',
    'Books',
    'Clothing',
    'Furniture',
    'Toys',
    'School Supplies',
    'Other',
  ];

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      imageQuality: 85,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() {
      _imageBase64 = base64Encode(bytes);
    });
  }

  void _removeImage() {
    setState(() {
      _imageBase64 = null;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Item newItem = Item(
        id:          DateTime.now().millisecondsSinceEpoch,
        name:        _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category:    _category,
        donor:       currentUser?.username ?? 'Anonymous',
        imageUrl:    _imageBase64,
      );

      globalItems.insert(0, newItem);

      currentUser?.donatedItems.add(newItem);

      setState(() {
        _submitted = true;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
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
          'Donate an Item',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 560),
          child: _submitted ? _buildSuccessPage() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildSuccessPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            const Text(
              'Thank You!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: kNavy,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your item has been added to the community.\nYou can now take items too!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: kGrey, height: 1.7),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BrowseScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kNavy,
                  foregroundColor: kWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Browse Items →',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Fill in the details of the item you want to donate.',
              style: TextStyle(fontSize: 13, color: kGrey, height: 1.6),
            ),
            const SizedBox(height: 24),
            const Text(
              'Item Photo',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kNavy,
              ),
            ),
            const SizedBox(height: 8),

            _imageBase64 == null
              ? GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: kCream,
                      border: Border.all(color: kBorder, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 40, color: kGold),
                        SizedBox(height: 10),
                        Text(
                          'Tap to upload a photo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kGrey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'JPG or PNG from your device',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        base64Decode(_imageBase64!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Row(
                        children: [
                          _imageButton('Change', kNavy, _pickImage),
                          const SizedBox(width: 8),
                          _imageButton('Remove', const Color(0xFFC0392B), _removeImage),
                        ],
                      ),
                    ),
                  ],
                ),

            const SizedBox(height: 20),

            const Text(
              'Item Name',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kNavy,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameCtrl,
              decoration: _fieldStyle('e.g. Rice Cooker, Blue Backpack...'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the item name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Category',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kNavy,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: _fieldStyle(''),
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kNavy,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descCtrl,
              maxLines: 4,
              decoration: _fieldStyle('Describe the item — condition, size, color...'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please add a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
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
                    fontSize: 15,
                  ),
                ),
                child: const Text('Submit Donation'),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kNavy,
                  side: const BorderSide(color: kGold),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _imageButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: kWhite,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      filled: true,
      fillColor: kCream,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
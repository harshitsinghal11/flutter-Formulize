import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/formula_model.dart';
import '../../../data/source/formula_local_data_source.dart';
import '../../formula_view/screens/formula_view_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {

  // Grabs the fresh IDs and the Database at the exact same time
  Future<List<FormulaModel>> _getFreshBookmarkedFormulas() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedIds = prefs.getStringList('bookmarked_formulas') ?? [];

    if (savedIds.isEmpty) {
      return [];
    }

    final allFormulas = await FormulaLocalDataSource().loadFormulas();
    return allFormulas.where((f) => savedIds.contains(f.id)).toList();
  }

  // --- THE NEW CLEAR ALL FUNCTION ---
  Future<void> _clearAllBookmarks() async {
    final prefs = await SharedPreferences.getInstance();

    // Wipes the saved list completely from the device!
    await prefs.remove('bookmarked_formulas');

    // Triggers the FutureBuilder to rebuild the screen (it will now see an empty list)
    setState(() {});

    // Show a quick success popup at the bottom of the screen
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'All bookmarks cleared!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Saved Formulas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Clear All Bookmarks?'),
              content: const Text('Are you sure you want to delete all your saved formulas? This cannot be undone.'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _clearAllBookmarks();
                  },
                  child: const Text('Clear All', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.delete_outline, color: Colors.white),
        label: const Text('Clear All', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        elevation: 4,
      ),

      body: FutureBuilder<List<FormulaModel>>(
        future: _getFreshBookmarkedFormulas(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading database.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final savedFormulas = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 80.0), // Added bottom padding so the FAB doesn't block the last card!
            itemCount: savedFormulas.length,
            itemBuilder: (context, index) {
              return FormulaCard(formula: savedFormulas[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No saved formulas yet.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the bookmark icon on any\nformula to save it here!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this!
import '../../../data/models/formula_model.dart';
import '../../../data/source/formula_local_data_source.dart';

class FormulaViewScreen extends StatelessWidget {
  final String className;
  final String chapterName;

  const FormulaViewScreen({
    Key? key,
    required this.className,
    required this.chapterName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String classNumber = className.replaceAll('Class ', '');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(chapterName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<FormulaModel>>(
        future: FormulaLocalDataSource().loadFormulas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading formulas.'));
          }

          final chapterFormulas = snapshot.data!.where((f) =>
          f.classLevel == classNumber && f.chapter == chapterName
          ).toList();

          if (chapterFormulas.isEmpty) {
            return const Center(child: Text('No formulas added for this chapter yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: chapterFormulas.length,
            itemBuilder: (context, index) {
              final formula = chapterFormulas[index];

              // We now return our custom Stateful widget here!
              return FormulaCard(formula: formula);
            },
          );
        },
      ),
    );
  }
}

// =====================================================================
// THE NEW STATEFUL CARD WIDGET
// This allows the bookmark icon to instantly update when tapped!
// =====================================================================

class FormulaCard extends StatefulWidget {
  final FormulaModel formula;

  const FormulaCard({Key? key, required this.formula}) : super(key: key);

  @override
  State<FormulaCard> createState() => _FormulaCardState();
}

class _FormulaCardState extends State<FormulaCard> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked(); // Check storage when the card first loads
  }

  // Reads the device storage to see if this formula's ID is saved
  Future<void> _checkIfBookmarked() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedIds = prefs.getStringList('bookmarked_formulas') ?? [];

    setState(() {
      isBookmarked = savedIds.contains(widget.formula.id);
    });
  }

  // Adds or removes the ID from storage when the user taps the icon
  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();

    // THE FIX: Use List<String>.from() to create a brand new, detached copy of the list!
    List<String> savedIds = List<String>.from(prefs.getStringList('bookmarked_formulas') ?? []);

    setState(() {
      if (isBookmarked) {
        savedIds.remove(widget.formula.id); // Remove it
        isBookmarked = false;
      } else {
        savedIds.add(widget.formula.id); // Save it
        isBookmarked = true;
      }
    });

    await prefs.setStringList('bookmarked_formulas', savedIds);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Empty box to balance the row so the text stays centered
                const SizedBox(width: 48),

                Expanded(
                  child: Text(
                    widget.formula.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // The actual Bookmark Icon Button!
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.blueAccent,
                  ),
                  onPressed: _toggleBookmark,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // --- THE MATH ---
            Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Math.tex(
                  widget.formula.latexCode,
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- THE EXPLANATION ---
            Text(
              widget.formula.explanation,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../data/models/formula_model.dart';
import '../../../data/source/formula_local_data_source.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Results for "$query"'),
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
            return const Center(child: Text('Error loading database.'));
          }

          // Convert query to lowercase for accurate matching
          final String lowerQuery = query.toLowerCase();

          // Filter logic: Check if the query matches the title, chapter, or ANY search tags
          final results = snapshot.data!.where((f) {
            final inTitle = f.title.toLowerCase().contains(lowerQuery);
            final inChapter = f.chapter.toLowerCase().contains(lowerQuery);
            final inTags = f.searchTags.any((tag) => tag.toLowerCase().contains(lowerQuery));

            return inTitle || inChapter || inTags;
          }).toList();

          if (results.isEmpty) {
            return const Center(
              child: Text(
                'No formulas found. Try a different keyword.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Display the results using the same UI layout as the Formula View
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final formula = results[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Class ${formula.classLevel} • ${formula.subject}',
                        style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formula.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Math.tex(
                            formula.latexCode,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        formula.explanation,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
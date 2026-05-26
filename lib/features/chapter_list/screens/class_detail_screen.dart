import 'package:flutter/material.dart';
import '../../../data/models/formula_model.dart';
import '../../../data/source/formula_local_data_source.dart';
import '../../formula_view/screens/formula_view_screen.dart';

class ClassDetailScreen extends StatelessWidget {
  final String className;
  const ClassDetailScreen({Key? key, required this.className}) : super(key: key);

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics': return Icons.science;
      case 'mathematics': return Icons.calculate;
      case 'chemistry': return Icons.biotech;
      case 'biology': return Icons.eco;
      default: return Icons.menu_book;
    }
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics': return Colors.deepPurpleAccent;
      case 'mathematics': return Colors.blueAccent;
      case 'chemistry': return Colors.orangeAccent;
      case 'biology': return Colors.green;
      default: return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String classNumber = className.replaceAll('Class ', '');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Syllabus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<FormulaModel>>(
        future: FormulaLocalDataSource().loadFormulas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading formulas.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No formulas found in database.'));
          }

          final allFormulas = snapshot.data!;
          final classFormulas = allFormulas.where((f) => f.classLevel == classNumber).toList();

          if (classFormulas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.construction, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Content coming soon for $className!',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }

          final Map<String, Set<String>> dynamicSyllabus = {};

          for (var formula in classFormulas) {
            if (!dynamicSyllabus.containsKey(formula.subject)) {
              dynamicSyllabus[formula.subject] = {};
            }
            dynamicSyllabus[formula.subject]!.add(formula.chapter);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: dynamicSyllabus.keys.length,
            itemBuilder: (context, index) {
              String subject = dynamicSyllabus.keys.elementAt(index);
              List<String> chapters = dynamicSyllabus[subject]!.toList();

              Color subjectColor = _getSubjectColor(subject);

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Ultra-rounded corners
                elevation: 4,
                shadowColor: Colors.black12, // Softer, more modern shadow
                clipBehavior: Clip.antiAlias,

                // --- MODERN TOUCH 3: Theme wrapper to remove ugly default ExpansionTile borders ---
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

                    // --- MODERN TOUCH 4: Sleek Icon Container ---
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: subjectColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getSubjectIcon(subject), color: subjectColor),
                    ),

                    title: Text(
                      subject,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    ),
                    iconColor: subjectColor,
                    collapsedIconColor: Colors.grey[400],

                    children: chapters.map((chapter) {
                      return Container(
                        // --- MODERN TOUCH 5: Left-accent border for chapter items ---
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            left: BorderSide(color: subjectColor.withOpacity(0.5), width: 3),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
                          title: Text(
                            chapter,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                          ),
                          onTap: () {
                            final tappedChapterData = classFormulas.firstWhere((f) => f.chapter == chapter);

                            if (tappedChapterData.containsFormulas) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormulaViewScreen(
                                    className: className,
                                    chapterName: chapter,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.menu_book, color: Colors.white),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          '"$chapter" is a theoretical chapter with no formulas.',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF1C0845), // Matches your premium purple!
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }).toList(),
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
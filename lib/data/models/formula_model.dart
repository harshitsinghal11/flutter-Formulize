class FormulaModel {
  final String id;
  final String classLevel;
  final String subject;
  final String chapter;
  final String title;
  final String latexCode;
  final String explanation;
  final bool containsFormulas;
  final List<String> searchTags;

  FormulaModel({
    required this.id,
    required this.classLevel,
    required this.subject,
    required this.chapter,
    required this.title,
    required this.latexCode,
    required this.explanation,
    required this.containsFormulas,
    required this.searchTags,
  });

  factory FormulaModel.fromJson(Map<String, dynamic> json) {
    return FormulaModel(
      id: json['id'] ?? '',
      classLevel: json['classLevel'] ?? '',
      subject: json['subject'] ?? '',
      chapter: json['chapter'] ?? '',
      title: json['title'] ?? '',
      latexCode: json['latexCode'] ?? '',
      explanation: json['explanation'] ?? '',
      // Correctly looks for 'containsFormulas' and defaults to false if missing
      containsFormulas: json['containsFormulas'] ?? false,
      searchTags: List<String>.from(json['searchTags'] ?? []),
    );
  }
}
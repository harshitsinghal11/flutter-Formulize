import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/formula_model.dart';

class FormulaLocalDataSource {

  Future<List<FormulaModel>> loadFormulas() async {
    List<dynamic> combinedJson = [];

    try {
      final String c9 = await rootBundle.loadString('assets/class9.json');
      combinedJson.addAll(json.decode(c9));
    } catch (e) {
      print("🚨 TYPO FOUND IN class9.json: $e");
    }

    try {
      final String c10 = await rootBundle.loadString('assets/class10.json');
      combinedJson.addAll(json.decode(c10));
    } catch (e) {
      print("🚨 TYPO FOUND IN class10.json: $e");
    }

    try {
      final String c11 = await rootBundle.loadString('assets/class11.json');
      combinedJson.addAll(json.decode(c11));
    } catch (e) {
      print("🚨 TYPO FOUND IN class11.json: $e");
    }

    try {
      final String c12 = await rootBundle.loadString('assets/class12.json');
      combinedJson.addAll(json.decode(c12));
    } catch (e) {
      print("🚨 TYPO FOUND IN class12.json: $e");
    }
    try {
      final String fundamentals = await rootBundle.loadString('assets/fundamentals.json');
      combinedJson.addAll(json.decode(fundamentals));
    } catch (e) {
      print("🚨 TYPO FOUND IN fundamentals.json: $e");
    }
    // Convert the successfully loaded data into Dart models
    return combinedJson.map((jsonItem) => FormulaModel.fromJson(jsonItem)).toList();
  }
}
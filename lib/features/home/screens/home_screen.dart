import 'package:flutter/material.dart';
import '../widgets/class_card.dart';
import '../widgets/home_search_bar.dart';
import '../../formula_view/screens/formula_view_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        // Makes the AppBar tall enough to hold both lines of text comfortably
        toolbarHeight: 128.0,
        backgroundColor: const Color(0xFF1C0845), // Your premium deep purple
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: false, // Forces the text to align to the left

        // Creates the beautiful curved bottom corners
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left-aligns the column
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Formulize',
                style: TextStyle(
                  fontSize: 34, // Large, bold brand name
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Smarter Way To Learning',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeSearchBar(),
            const SizedBox(height: 30),

            // --- SECTION 1: CLASSES ---
            const Text(
              'Navigate By Class',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: const [
                ClassCard(className: 'Class 9', color: Colors.orangeAccent),
                ClassCard(className: 'Class 10', color: Colors.green),
                ClassCard(className: 'Class 11', color: Colors.purpleAccent),
                ClassCard(className: 'Class 12', color: Colors.redAccent),
              ],
            ),

            const SizedBox(height: 30),

            // --- SECTION 2: FUNDAMENTALS ---
            const Text(
              'Fundamentals',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildFundamentalCard(
                      context,
                      'Algebraic Identities',
                      Icons.calculate,
                      Colors.indigo
                  ),
                  const SizedBox(width: 16),
                  _buildFundamentalCard(
                      context,
                      'Trigonometry Basics',
                      Icons.change_history,
                      Colors.teal
                  ),
                  const SizedBox(width: 16),
                  _buildFundamentalCard(
                      context,
                      'Logarithm Rules',
                      Icons.functions,
                      Colors.deepOrange
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFundamentalCard(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormulaViewScreen(
              className: 'Fundamentals', // Matches our new JSON structure
              chapterName: title,        // Matches our new JSON structure
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
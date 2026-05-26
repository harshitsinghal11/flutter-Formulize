import 'package:flutter/material.dart';
import '../../chapter_list/screens/class_detail_screen.dart';

class ClassCard extends StatelessWidget {
  final String className;
  final Color color;

  const ClassCard({
    Key? key,
    required this.className,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassDetailScreen(className: className),
          ),
        );
      },
      child: Container(
        // Ensure the contents don't bleed outside the rounded corners
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          // 1. Sleek Gradient instead of a flat color
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.6), // Lighter at the top left
              color,                  // Deeper at the bottom right
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20), // Slightly rounder corners
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12, // Softer, wider shadow
              offset: const Offset(0, 6),
            ),
          ],
        ),
        // 2. Stack allows us to layer the background icon and the text
        child: Stack(
          children: [
            // --- THE BACKGROUND WATERMARK ICON ---
            Positioned(
              right: -15, // Pushed slightly off-screen
              top: -15,   // Pushed slightly off-screen
              child: Icon(
                Icons.school, // A nice academic icon
                size: 110,
                color: Colors.white.withOpacity(0.15), // Barely visible watermark
              ),
            ),

            // --- THE MAIN CONTENT ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A subtle circular arrow indicating navigation
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),

                  const Spacer(), // Pushes the text to the bottom

                  // The Class Title
                  Text(
                    className,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // A subtle subtitle
                  Text(
                    'View Syllabus',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';

class StrengthsSection extends StatelessWidget {
  final List<String> items;

  const StrengthsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(AppConstants.successHex).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(AppConstants.successHex).withValues(alpha: 0.2),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: const Icon(Icons.check_circle_outline, color: Color(AppConstants.successHex)),
          title: Text(
            'STRENGTHS',
            style: GoogleFonts.cinzel(
              fontWeight: FontWeight.bold,
              color: const Color(AppConstants.successHex),
              letterSpacing: 1.5,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(AppConstants.successHex), fontSize: 18)),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

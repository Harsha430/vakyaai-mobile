import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/analysis_provider.dart';
import '../core/constants.dart';
import '../widgets/score_chart.dart';
import '../widgets/strengths_section.dart';
import '../widgets/weaknesses_section.dart';
import '../widgets/improved_pitch_card.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisProvider);
    final analysis = analysisState.analysis;

    if (analysis == null) {
      return const Scaffold(
        body: Center(child: Text('No data available')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(AppConstants.primaryBgHex),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(AppConstants.accentHex)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'ANALYSIS RESULT',
          style: GoogleFonts.cinzel(
            color: const Color(AppConstants.accentHex),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Overall Score Card
            ResultCard(
              child: Column(
                children: [
                  Text(
                    'OVERALL RESONANCE',
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      color: const Color(AppConstants.secondaryHex),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: analysis.overallScore / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.white10,
                          color: const Color(AppConstants.accentHex),
                        ),
                      ),
                      Text(
                        '${analysis.overallScore.round()}%',
                        style: GoogleFonts.cinzel(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(AppConstants.accentHex),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // 2. Score Chart
            ResultCard(
              title: 'ATTRIBUTE BREAKDOWN',
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ScoreChartWidget(scores: analysis.scores),
              ),
            ),

            const SizedBox(height: 20),

            // 3. Improved Pitch
            ImprovedPitchCard(pitch: analysis.improvedPitch),

            const SizedBox(height: 20),

            // 4. Strengths & Weaknesses
            StrengthsSection(items: analysis.strengths),
            const SizedBox(height: 20),
            WeaknessesSection(items: analysis.weaknesses),
            
            const SizedBox(height: 20),
            
            // 5. Suggestions
            ResultCard(
              title: 'SUGGESTIONS FOR REFINEMENT',
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: analysis.suggestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(AppConstants.accentHex), size: 16),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            analysis.suggestions[index],
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const ResultCard({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(AppConstants.accentHex).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: GoogleFonts.cinzel(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(AppConstants.accentHex),
                letterSpacing: 1.5,
              ),
            ),
            const Divider(color: Colors.white10, height: 24),
          ],
          child,
        ],
      ),
    );
  }
}

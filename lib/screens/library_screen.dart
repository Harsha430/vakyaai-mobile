import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../providers/history_provider.dart';
import '../models/analysis_model.dart';
import '../core/constants.dart';
import 'dashboard_screen.dart';
import '../providers/analysis_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LIBRARY ARCHIVES',
          style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(AppConstants.primaryBgHex)),
        child: historyState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : historyState.analyses.isEmpty
                ? _buildEmptyState()
                : _buildHistoryList(context, ref, historyState.analyses),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu, size: 64, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            'NO MANUSCRIPTS FOUND',
            style: GoogleFonts.cinzel(color: Colors.white24, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, WidgetRef ref, List<AnalysisModel> analyses) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: analyses.length,
      itemBuilder: (context, index) {
        final analysis = analyses[index];
        return Card(
          color: Colors.white.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            title: Text(
              'Analysis ${analysis.analysisId.substring(0, 8)}',
              style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Score: ${analysis.overallScore.toStringAsFixed(1)}%',
              style: GoogleFonts.inter(color: const Color(AppConstants.accentHex)),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
            onTap: () => _showRecoveryModal(context, ref, analysis),
          ),
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
      },
    );
  }

  void _showRecoveryModal(BuildContext context, WidgetRef ref, AnalysisModel analysis) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassmorphicContainer(
        width: double.infinity,
        height: 400,
        borderRadius: 24,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.1), Colors.white.withValues(alpha: 0.05)],
        ),
        borderGradient: LinearGradient(
          colors: [const Color(AppConstants.accentHex).withValues(alpha: 0.5), Colors.transparent],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MANUSCRIPT RECOVERY',
                style: GoogleFonts.cinzel(
                  color: const Color(AppConstants.accentHex),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Overall Resonance: ${analysis.overallScore.toStringAsFixed(1)}%',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                analysis.improvedPitch,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(analysisProvider.notifier).setAnalysis(analysis);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  },
                  child: const Text('OPEN ARCHIVE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/analysis_provider.dart';
import '../models/analysis_model.dart';
import '../core/constants.dart';
import '../widgets/score_chart.dart';
import '../widgets/strengths_section.dart';
import '../widgets/weaknesses_section.dart';
import '../widgets/improved_pitch_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(analysisProvider);
    final analysis = analysisState.analysis;

    if (analysis == null) {
      return const Scaffold(body: Center(child: Text('No data found.')));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'COMMAND CENTER',
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.bold,
            color: const Color(AppConstants.accentHex),
            letterSpacing: 2,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(AppConstants.accentHex),
          labelColor: const Color(AppConstants.accentHex),
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 12),
          tabs: const [
            Tab(text: 'LAB 1: INSIGHTS'),
            Tab(text: 'LAB 2: OPTIMIZE'),
            Tab(text: 'LAB 3: DECK'),
            Tab(text: 'LAB 4: GROWTH'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(AppConstants.primaryBgHex)),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildInsightsTab(analysis),
            _buildOptimizeTab(analysis),
            _buildDeckTab(analysis),
            _buildGrowthTab(analysis),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsTab(AnalysisModel analysis) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: AnimateList(
          interval: 100.ms,
          effects: [const FadeEffect(), const SlideEffect(begin: Offset(0, 0.1))],
          children: [
            Text(
              'PERFORMANCE RADAR',
              style: GoogleFonts.cinzel(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 24),
            ScoreChartWidget(scores: analysis.scores),
            const SizedBox(height: 32),
            StrengthsSection(items: analysis.strengths),
            const SizedBox(height: 16),
            WeaknessesSection(items: analysis.weaknesses),
            const SizedBox(height: 32),
            _buildChecklist(analysis),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklist(AnalysisModel analysis) {
    final checklist = analysis.checklist.isNotEmpty ? analysis.checklist : [
      {'label': 'Market Size Mentioned', 'status': true},
      {'label': 'Monetization Strategy', 'status': false},
      {'label': 'Competitive Advantage', 'status': true},
      {'label': 'Team Expertise', 'status': false},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COMPONENT CHECKLIST',
          style: GoogleFonts.cinzel(fontSize: 18, color: const Color(AppConstants.accentHex)),
        ),
        const SizedBox(height: 16),
        ...checklist.map((item) => Card(
          color: Colors.white.withValues(alpha: 0.05),
          child: ListTile(
            leading: Icon(
              item['status'] ? Icons.check_circle : Icons.cancel,
              color: item['status'] ? Colors.green : Colors.red,
            ),
            title: Text(item['label'], style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
          ),
        )),
      ],
    );
  }

  Widget _buildOptimizeTab(AnalysisModel analysis) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: AnimateList(
          interval: 100.ms,
          effects: [const FadeEffect(), const SlideEffect(begin: Offset(0, 0.1))],
          children: [
            ImprovedPitchCard(pitch: analysis.improvedPitch),
            const SizedBox(height: 32),
            _buildMetadataFactory(analysis),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataFactory(AnalysisModel analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'METADATA FACTORY',
          style: GoogleFonts.cinzel(fontSize: 18, color: const Color(AppConstants.accentHex)),
        ),
        const SizedBox(height: 16),
        _buildMetadataItem('LinkedIn Hook', 'Generate a professional hook for your pitch.'),
        _buildMetadataItem('Elevator Pitch', 'A 30-second version of your vision.'),
        _buildMetadataItem('Formal Email', 'Craft an introductory email to stakeholders.'),
      ],
    );
  }

  Widget _buildMetadataItem(String title, String desc) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(desc, style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
        trailing: const Icon(Icons.auto_awesome, color: Color(AppConstants.accentHex)),
        onTap: () {
          // Future: Open detail and copy
        },
      ),
    );
  }

  Widget _buildDeckTab(AnalysisModel analysis) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: AnimateList(
          interval: 50.ms,
          effects: [const FadeEffect(), const SlideEffect(begin: Offset(0.1, 0))],
          children: [
            Text(
              'DECK ARCHITECT',
              style: GoogleFonts.cinzel(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 24),
            ...List.generate(6, (index) => _buildSlideCard(index + 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideCard(int index) {
    final slides = [
      'Problem Statement',
      'Value Proposition',
      'Market Opportunity',
      'Competitive Advantage',
      'Business Model',
      'The Ask / Call to Action'
    ];
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(AppConstants.accentHex),
              child: Text('$index', style: const TextStyle(color: Colors.black)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                slides[index - 1],
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthTab(AnalysisModel analysis) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: AnimateList(
          interval: 100.ms,
          effects: [const FadeEffect()],
          children: [
            Text(
              'PERSONALIZED ROADMAP',
              style: GoogleFonts.cinzel(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 24),
            _buildRoadmapStepper(analysis),
            const SizedBox(height: 48),
            _buildPracticeMode(analysis),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeMode(AnalysisModel analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRACTICE MODE: JUDGE DEFENSE',
          style: GoogleFonts.cinzel(fontSize: 18, color: const Color(AppConstants.accentHex)),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(AppConstants.accentHex).withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Text(
                '"How do you plan to scale this vision within the next 12 months?"',
                style: GoogleFonts.inter(color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 16),
                textAlign: TextAlign.center,
              ).animate().fadeIn().slideY(begin: 0.2),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type your defense...',
                  hintStyle: GoogleFonts.inter(color: Colors.white24),
                  fillColor: Colors.black.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('SUBMIT RESPONSE'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoadmapStepper(AnalysisModel analysis) {
    final roadmap = analysis.roadmap.isNotEmpty ? analysis.roadmap : ['Evaluating Clarity', 'Refining Structure', 'Mastering Impact'];
    return Column(
      children: List.generate(roadmap.length, (index) {
        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(AppConstants.accentHex), width: 2),
                    ),
                  ),
                  if (index != roadmap.length - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: const Color(AppConstants.accentHex).withValues(alpha: 0.3),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    roadmap[index],
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

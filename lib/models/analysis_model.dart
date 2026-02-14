class AnalysisModel {
  final Map<String, int> scores;
  final double overallScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> suggestions;
  final String improvedPitch;
  final String analysisId;
  
  // Phase 2 additions
  final double confidenceScore;
  final Map<String, int> fillerWords;
  final List<Map<String, dynamic>> checklist;
  final List<String> roadmap;
  final List<Map<String, String>> deckStructure;

  AnalysisModel({
    required this.scores,
    required this.overallScore,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
    required this.improvedPitch,
    required this.analysisId,
    this.confidenceScore = 0.0,
    this.fillerWords = const {},
    this.checklist = const [],
    this.roadmap = const [],
    this.deckStructure = const [],
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      scores: Map<String, int>.from(json['scores'] ?? {}),
      overallScore: (json['overall_score'] ?? 0.0).toDouble(),
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      suggestions: List<String>.from(json['suggestions'] ?? []),
      improvedPitch: json['improved_pitch'] ?? '',
      analysisId: json['analysis_id'] ?? '',
      confidenceScore: (json['confidence_score'] ?? 0.0).toDouble(),
      fillerWords: Map<String, int>.from(json['filler_words'] ?? {}),
      checklist: List<Map<String, dynamic>>.from(json['checklist'] ?? []),
      roadmap: List<String>.from(json['roadmap'] ?? []),
      deckStructure: List<Map<String, String>>.from(json['deck_structure'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scores': scores,
      'overall_score': overallScore,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'suggestions': suggestions,
      'improved_pitch': improvedPitch,
      'analysis_id': analysisId,
      'confidence_score': confidenceScore,
      'filler_words': fillerWords,
      'checklist': checklist,
      'roadmap': roadmap,
      'deck_structure': deckStructure,
    };
  }
}

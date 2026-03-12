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
  final List<Map<String, String>> resources;
  
  // Metadata Factory additions
  final String linkedinHook;
  final String elevatorPitch;
  final String formalEmail;

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
    this.resources = const [],
    this.linkedinHook = '',
    this.elevatorPitch = '',
    this.formalEmail = '',
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic v) => int.tryParse(v.toString()) ?? 0;
    double safeDouble(dynamic v) => double.tryParse(v.toString()) ?? 0.0;

    return AnalysisModel(
      scores: (json['scores'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), safeInt(v)),
          ) ?? {},
      overallScore: safeDouble(json['overall_score']),
      strengths: (json['strengths'] as List?)?.map((e) => e.toString()).toList() ?? [],
      weaknesses: (json['weaknesses'] as List?)?.map((e) => e.toString()).toList() ?? [],
      suggestions: (json['suggestions'] as List?)?.map((e) => e.toString()).toList() ?? [],
      improvedPitch: json['improved_pitch']?.toString() ?? '',
      analysisId: json['analysis_id']?.toString() ?? '',
      confidenceScore: safeDouble(json['confidence_score']),
      fillerWords: (json['filler_words'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), safeInt(v)),
          ) ?? {},
      checklist: (json['checklist'] as List?)?.map((e) {
            if (e is Map) {
              return {
                'label': e['label']?.toString() ?? '',
                'status': e['status'] == true || e['status'].toString().toLowerCase() == 'true',
              };
            }
            return <String, dynamic>{};
          }).toList() ?? [],
      roadmap: (json['roadmap'] as List?)?.map((e) => e.toString()).toList() ?? [],
      deckStructure: (json['deck_structure'] as List?)?.map((e) {
            if (e is Map) {
              return (e).map((k, v) => MapEntry(k.toString(), v.toString()));
            }
            return <String, String>{};
          }).toList() ?? [],
      resources: (json['resources'] as List?)?.map((e) {
            if (e is Map) {
              return (e).map((k, v) => MapEntry(k.toString(), v.toString()));
            }
            return <String, String>{};
          }).toList() ?? [],
      linkedinHook: json['linkedin_hook']?.toString() ?? '',
      elevatorPitch: json['elevator_pitch']?.toString() ?? '',
      formalEmail: json['formal_email']?.toString() ?? '',
    );
  }
  
  // Debug helper
  void printDebugInfo() {
    print('📦 [MODEL-DEBUG] ID: $analysisId');
    print('📦 [MODEL-DEBUG] Linkedin: ${linkedinHook.length > 20 ? linkedinHook.substring(0, 20) : linkedinHook}...');
    print('📦 [MODEL-DEBUG] Elevator: ${elevatorPitch.length > 20 ? elevatorPitch.substring(0, 20) : elevatorPitch}...');
    print('📦 [MODEL-DEBUG] Email: ${formalEmail.length > 20 ? formalEmail.substring(0, 20) : formalEmail}...');
    print('📦 [MODEL-DEBUG] Deck count: ${deckStructure.length}');
    print('📦 [MODEL-DEBUG] Roadmap count: ${roadmap.length}');
    print('📦 [MODEL-DEBUG] Checklist count: ${checklist.length}');
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
      'resources': resources,
    };
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analysis_model.dart';
import '../services/api_service.dart';
import 'history_provider.dart';

// Provider for the API Service
final apiServiceProvider = Provider((ref) => ApiService());

// State class for Analysis
enum ErrorType { none, validation, major }

class AnalysisState {
  final bool isLoading;
  final AnalysisModel? analysis;
  final String? errorMessage;
  final ErrorType errorType;
  final String lastPitch;

  AnalysisState({
    this.isLoading = false,
    this.analysis,
    this.errorMessage,
    this.errorType = ErrorType.none,
    this.lastPitch = '',
  });

  AnalysisState copyWith({
    bool? isLoading,
    AnalysisModel? analysis,
    String? errorMessage,
    ErrorType? errorType,
    String? lastPitch,
  }) {
    return AnalysisState(
      isLoading: isLoading ?? this.isLoading,
      analysis: analysis ?? this.analysis,
      errorMessage: errorMessage ?? this.errorMessage,
      errorType: errorType ?? this.errorType,
      lastPitch: lastPitch ?? this.lastPitch,
    );
  }
}

// Notifier for Analysis
class AnalysisNotifier extends StateNotifier<AnalysisState> {
  final ApiService _apiService;
  final Ref _ref;

  AnalysisNotifier(this._apiService, this._ref) : super(AnalysisState());

  Future<void> analyzePitch(String pitchText) async {
    print('🎬 [PROVIDER] analyzePitch called with ${pitchText.length} chars');
    
    if (pitchText.trim().isEmpty) {
      print('⚠️ [PROVIDER] Empty pitch text');
      state = state.copyWith(
        errorMessage: 'Please enter your pitch first.',
        errorType: ErrorType.validation,
      );
      return;
    }

    print('⏳ [PROVIDER] Setting loading state...');
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorType: ErrorType.none,
      lastPitch: pitchText,
    );

    try {
      print('🔄 [PROVIDER] Calling API service...');
      final analysis = await _apiService.analyzePitch(pitchText);
      print('✅ [PROVIDER] API call successful! Analysis ID: ${analysis.analysisId}');
      print('📊 [PROVIDER] Overall score: ${analysis.overallScore}');
      print('🔧 [PROVIDER] Updating state with analysis...');
      
      // VERIFICATION PRINT
      analysis.printDebugInfo();
      
      state = state.copyWith(isLoading: false, analysis: analysis);
      print('✅ [PROVIDER] State updated! isLoading: ${state.isLoading}, analysis: ${state.analysis != null}');

      // Save to history
      print('💾 [PROVIDER] Saving to history...');
      _ref.read(historyProvider.notifier).addAnalysis(analysis);
      print('✅ [PROVIDER] Saved to history');
    } catch (e) {
      print('❌ [PROVIDER] Error caught: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        errorType: ErrorType.major,
      );
    }
  }

  void retry() {
    if (state.lastPitch.isNotEmpty) {
      analyzePitch(state.lastPitch);
    }
  }

  void reset() {
    state = AnalysisState();
  }

  void setAnalysis(AnalysisModel analysis) {
    state = state.copyWith(analysis: analysis, isLoading: false, errorMessage: null);
  }
}

// Provider for the Analysis state
final analysisProvider = StateNotifierProvider<AnalysisNotifier, AnalysisState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AnalysisNotifier(apiService, ref);
});

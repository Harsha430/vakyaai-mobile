import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/analysis_model.dart';

class HistoryState {
  final List<AnalysisModel> analyses;
  final bool isLoading;

  HistoryState({this.analyses = const [], this.isLoading = false});

  HistoryState copyWith({List<AnalysisModel>? analyses, bool? isLoading}) {
    return HistoryState(
      analyses: analyses ?? this.analyses,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final _storage = const FlutterSecureStorage();
  static const _historyKey = 'pitch_history';

  HistoryNotifier() : super(HistoryState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true);
    final historyJson = await _storage.read(key: _historyKey);
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      final analyses = decoded.map((e) => AnalysisModel.fromJson(e)).toList();
      state = state.copyWith(analyses: analyses, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addAnalysis(AnalysisModel analysis) async {
    final updatedAnalyses = [analysis, ...state.analyses];
    state = state.copyWith(analyses: updatedAnalyses);
    await _storage.write(
      key: _historyKey,
      value: jsonEncode(updatedAnalyses.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clearHistory() async {
    await _storage.delete(key: _historyKey);
    state = HistoryState();
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier();
});

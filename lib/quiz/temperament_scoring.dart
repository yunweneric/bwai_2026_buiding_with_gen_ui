import 'quiz_models.dart';

/// Running point totals for the four classical temperaments.
class TemperamentScores {
  int sanguine = 0;
  int choleric = 0;
  int melancholic = 0;
  int phlegmatic = 0;

  void add(TemperamentWeights w) {
    sanguine += w.sanguine;
    choleric += w.choleric;
    melancholic += w.melancholic;
    phlegmatic += w.phlegmatic;
  }

  TemperamentBreakdown toBreakdown() {
    final total = sanguine + choleric + melancholic + phlegmatic;
    if (total <= 0) {
      return TemperamentBreakdown(
        sanguinePct: 25,
        cholericPct: 25,
        melancholicPct: 25,
        phlegmaticPct: 25,
        dominant: TemperamentId.sanguine,
      );
    }
    final parts = [
      sanguine * 100.0 / total,
      choleric * 100.0 / total,
      melancholic * 100.0 / total,
      phlegmatic * 100.0 / total,
    ];
    final ints = parts.map((p) => p.floor()).toList();
    var remainder = 100 - ints.reduce((a, b) => a + b);
    final order = [0, 1, 2, 3]
      ..sort((a, b) {
        final fa = parts[a] - parts[a].floor();
        final fb = parts[b] - parts[b].floor();
        return fb.compareTo(fa);
      });
    for (var i = 0; i < remainder; i++) {
      ints[order[i]]++;
    }
    final entries = [
      (TemperamentId.sanguine, sanguine),
      (TemperamentId.choleric, choleric),
      (TemperamentId.melancholic, melancholic),
      (TemperamentId.phlegmatic, phlegmatic),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    return TemperamentBreakdown(
      sanguinePct: ints[0],
      cholericPct: ints[1],
      melancholicPct: ints[2],
      phlegmaticPct: ints[3],
      dominant: entries.first.$1,
    );
  }
}

class TemperamentBreakdown {
  const TemperamentBreakdown({
    required this.sanguinePct,
    required this.cholericPct,
    required this.melancholicPct,
    required this.phlegmaticPct,
    required this.dominant,
  });

  final int sanguinePct;
  final int cholericPct;
  final int melancholicPct;
  final int phlegmaticPct;
  final TemperamentId dominant;

  int pctFor(TemperamentId id) => switch (id) {
    TemperamentId.sanguine => sanguinePct,
    TemperamentId.choleric => cholericPct,
    TemperamentId.melancholic => melancholicPct,
    TemperamentId.phlegmatic => phlegmaticPct,
  };
}

/// Builds scores from answered question indices and raw answer payloads.
TemperamentScores computeScores(
  List<QuizQuestion> questions,
  Map<int, Object?> answers,
) {
  final scores = TemperamentScores();
  for (var i = 0; i < questions.length; i++) {
    final q = questions[i];
    final raw = answers[q.index];
    if (raw == null) continue;
    final w = q.resolveWeights(raw);
    if (w != null) scores.add(w);
  }
  return scores;
}

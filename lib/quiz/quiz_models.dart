/// Classical four temperaments (dominant + blend).
enum TemperamentId { sanguine, choleric, melancholic, phlegmatic }

extension TemperamentIdX on TemperamentId {
  String get label => switch (this) {
    TemperamentId.sanguine => 'Sanguine',
    TemperamentId.choleric => 'Choleric',
    TemperamentId.melancholic => 'Melancholic',
    TemperamentId.phlegmatic => 'Phlegmatic',
  };

  String get emoji => switch (this) {
    TemperamentId.sanguine => '🎉',
    TemperamentId.choleric => '⚡',
    TemperamentId.melancholic => '🌙',
    TemperamentId.phlegmatic => '🌊',
  };
}

/// Point contribution toward each temperament for one answer.
class TemperamentWeights {
  const TemperamentWeights({
    this.sanguine = 0,
    this.choleric = 0,
    this.melancholic = 0,
    this.phlegmatic = 0,
  });

  final int sanguine;
  final int choleric;
  final int melancholic;
  final int phlegmatic;

  static const zero = TemperamentWeights();
}

enum QuestionInputKind {
  selectCards,
  radioButtons,
  yesNoCards,
  imageChoiceCards,
  sliderSlowFast,
  slider1to5,
  toggleRoutineSpontaneity,
  personalityCards,
}

/// One selectable option (cards, radio, dropdown, etc.).
class QuizOption {
  const QuizOption({
    required this.id,
    required this.label,
    this.emoji,
    required this.weights,
  });

  final String id;
  final String label;
  final String? emoji;
  final TemperamentWeights weights;
}

/// Slider step: label + weights at that tick (0-based index).
class SliderStep {
  const SliderStep({required this.label, required this.weights});

  final String label;
  final TemperamentWeights weights;
}

class QuizQuestion {
  const QuizQuestion({
    required this.index,
    required this.prompt,
    required this.kind,
    this.subtitle,
    this.options = const [],
    this.sliderSteps = const [],
    this.toggleLeftLabel,
    this.toggleRightLabel,
    this.toggleLeftWeights,
    this.toggleRightWeights,
  });

  /// 1-based index as in the spec table.
  final int index;
  final String prompt;
  final String? subtitle;
  final QuestionInputKind kind;
  final List<QuizOption> options;
  final List<SliderStep> sliderSteps;
  final String? toggleLeftLabel;
  final String? toggleRightLabel;
  final TemperamentWeights? toggleLeftWeights;
  final TemperamentWeights? toggleRightWeights;

  /// [raw] is option id [String], slider tick [int], or toggle [bool] false=left true=right.
  TemperamentWeights? resolveWeights(Object? raw) {
    switch (kind) {
      case QuestionInputKind.sliderSlowFast:
      case QuestionInputKind.slider1to5:
        if (raw is! int || raw < 0 || raw >= sliderSteps.length) {
          return null;
        }
        return sliderSteps[raw].weights;
      case QuestionInputKind.toggleRoutineSpontaneity:
        if (raw is! bool) return null;
        return raw ? toggleRightWeights : toggleLeftWeights;
      default:
        if (raw is! String) return null;
        for (final o in options) {
          if (o.id == raw) return o.weights;
        }
        return null;
    }
  }
}

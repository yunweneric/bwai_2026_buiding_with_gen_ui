import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_to_genui/quiz/quiz_models.dart';
import 'package:intro_to_genui/ui/game_theme.dart';
import 'package:intro_to_genui/ui/hover_lift.dart';
import 'package:intro_to_genui/ui/stagger_entry.dart';

const Duration _kStaggerStep = Duration(milliseconds: 55);
const Duration _kOptionEntryDelay = Duration(milliseconds: 80);

Duration _delayFor(int index) => _kOptionEntryDelay + _kStaggerStep * index;

/// Pick a column count for option grids based on the available width.
int _columnsFor(double width, {required int minColumns, required int maxColumns}) {
  if (width >= 1100) return maxColumns;
  if (width >= 760) return maxColumns.clamp(minColumns, 3);
  if (width >= 520) return 2;
  return minColumns;
}

/// Renders the correct refined control for one [QuizQuestion].
class QuestionInputView extends StatelessWidget {
  const QuestionInputView({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuizQuestion question;
  final Object? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    switch (question.kind) {
      case QuestionInputKind.selectCards:
      case QuestionInputKind.imageChoiceCards:
        return _SelectCardsGrid(
          question: question,
          value: value as String?,
          onChanged: onChanged,
        );
      case QuestionInputKind.personalityCards:
        return _PersonalityCards(
          question: question,
          value: value as String?,
          onChanged: onChanged,
        );
      case QuestionInputKind.radioButtons:
        return _RadioGrid(
          question: question,
          value: value as String?,
          onChanged: onChanged,
        );
      case QuestionInputKind.yesNoCards:
        return _YesNoCards(
          question: question,
          value: value as String?,
          onChanged: onChanged,
        );
      case QuestionInputKind.sliderSlowFast:
      case QuestionInputKind.slider1to5:
        return _ScalePicker(
          question: question,
          value: value as int?,
          onChanged: onChanged,
        );
      case QuestionInputKind.toggleRoutineSpontaneity:
        return _RoutineToggle(
          question: question,
          value: value as bool?,
          onChanged: onChanged,
        );
    }
  }
}

class _SelectCardsGrid extends StatelessWidget {
  const _SelectCardsGrid({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuizQuestion question;
  final String? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = _columnsFor(c.maxWidth, minColumns: 2, maxColumns: 4);
        const gap = 16.0;
        final cardWidth = (c.maxWidth - gap * (cols - 1)) / cols;
        final tall = question.kind == QuestionInputKind.imageChoiceCards;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < question.options.length; i++)
              StaggerEntry(
                delay: _delayFor(i),
                child: SizedBox(
                  width: cardWidth,
                  child: _OptionCard(
                    option: question.options[i],
                    selected: value == question.options[i].id,
                    onTap: () => onChanged(question.options[i].id),
                    tall: tall,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
    this.tall = false,
  });

  final QuizOption option;
  final bool selected;
  final VoidCallback onTap;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(minHeight: tall ? 180 : 150),
            decoration: GameTheme.selectableCard(selected: selected),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (option.emoji != null)
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? GameColors.primary.withValues(alpha: 0.1)
                              : GameColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(option.emoji!, style: const TextStyle(fontSize: 26)),
                      )
                    else
                      const SizedBox.shrink(),
                    AnimatedScale(
                      duration: const Duration(milliseconds: 220),
                      scale: selected ? 1 : 0,
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: GameColors.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  option.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: GameColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PersonalityCards extends StatelessWidget {
  const _PersonalityCards({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuizQuestion question;
  final String? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth >= 720 ? 2 : 1;
        const gap = 14.0;
        final cardWidth = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < question.options.length; i++)
              StaggerEntry(
                delay: _delayFor(i),
                child: SizedBox(
                  width: cardWidth,
                  child: HoverLift(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => onChanged(question.options[i].id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.all(18),
                          decoration: GameTheme.selectableCard(
                            selected: value == question.options[i].id,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (question.options[i].emoji != null)
                                Container(
                                  width: 52,
                                  height: 52,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: value == question.options[i].id
                                        ? GameColors.primary.withValues(alpha: 0.1)
                                        : GameColors.surfaceMuted,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    question.options[i].emoji!,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  question.options[i].label,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: GameColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              AnimatedScale(
                                duration: const Duration(milliseconds: 220),
                                scale: value == question.options[i].id ? 1 : 0,
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  color: GameColors.primary,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RadioGrid extends StatelessWidget {
  const _RadioGrid({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuizQuestion question;
  final String? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth >= 720 ? 2 : 1;
        const gap = 12.0;
        final cardWidth = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < question.options.length; i++)
              StaggerEntry(
                delay: _delayFor(i),
                child: SizedBox(
                  width: cardWidth,
                  child: HoverLift(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => onChanged(question.options[i].id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          decoration: GameTheme.selectableCard(
                            selected: value == question.options[i].id,
                          ),
                          child: Row(
                            children: [
                              _RadioDot(selected: value == question.options[i].id),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  question.options[i].label,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: GameColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? GameColors.primary : GameColors.border,
          width: 2,
        ),
        color: selected ? GameColors.primary.withValues(alpha: 0.08) : Colors.white,
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: selected ? 10 : 0,
          height: selected ? 10 : 0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: GameColors.primary,
          ),
        ),
      ),
    );
  }
}

class _YesNoCards extends StatelessWidget {
  const _YesNoCards({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuizQuestion question;
  final String? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 600;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: wide ? 520 : c.maxWidth),
            child: Row(
              children: [
                for (var i = 0; i < question.options.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 0 : 8,
                        right: i == question.options.length - 1 ? 0 : 8,
                      ),
                      child: StaggerEntry(
                        delay: _delayFor(i),
                        child: HoverLift(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () => onChanged(question.options[i].id),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOut,
                                height: wide ? 180 : 140,
                                decoration: GameTheme.selectableCard(
                                  selected: value == question.options[i].id,
                                  accent: question.options[i].id == 'yes'
                                      ? GameColors.success
                                      : GameColors.danger,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      question.options[i].emoji ?? '',
                                      style: const TextStyle(fontSize: 44),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      question.options[i].label,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: GameColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ScalePicker extends StatelessWidget {
  const _ScalePicker({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuizQuestion question;
  final int? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final steps = question.sliderSteps;
    final max = steps.length - 1;
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 600;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StaggerEntry(
              delay: _delayFor(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      steps.first.label,
                      style: GameTheme.body(size: 13, weight: FontWeight.w600),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      steps.last.label,
                      textAlign: TextAlign.right,
                      style: GameTheme.body(size: 13, weight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            StaggerEntry(
              delay: _delayFor(1),
              child: Row(
                children: [
                  for (var i = 0; i <= max; i++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: i == 0 ? 0 : 6,
                          right: i == max ? 0 : 6,
                        ),
                        child: HoverLift(
                          scale: 1.04,
                          lift: 2,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => onChanged(i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOut,
                                height: wide ? 72 : 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: value == i
                                      ? GameColors.primary
                                      : GameColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: value == i
                                        ? GameColors.primary
                                        : GameColors.border,
                                    width: value == i ? 2 : 1,
                                  ),
                                  boxShadow: value == i
                                      ? [
                                          BoxShadow(
                                            color: GameColors.primary.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 14,
                                            offset: const Offset(0, 6),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  '${i + 1}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: wide ? 22 : 17,
                                    fontWeight: FontWeight.w800,
                                    color: value == i
                                        ? Colors.white
                                        : GameColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            StaggerEntry(
              delay: _delayFor(2),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Container(
                    key: ValueKey<int?>(value),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: GameColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: GameColors.primary.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Text(
                      value == null
                          ? 'Pick a number along the scale'
                          : steps[value!.clamp(0, max)].label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: GameColors.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RoutineToggle extends StatelessWidget {
  const _RoutineToggle({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final QuizQuestion question;
  final bool? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = [
      (false, question.toggleLeftLabel ?? 'Left', Icons.calendar_today_rounded),
      (true, question.toggleRightLabel ?? 'Right', Icons.bolt_rounded),
    ];
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 600;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: wide ? 520 : c.maxWidth),
            child: Row(
              children: [
                for (var i = 0; i < options.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 0 : 8,
                        right: i == options.length - 1 ? 0 : 8,
                      ),
                      child: StaggerEntry(
                        delay: _delayFor(i),
                        child: HoverLift(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () => onChanged(options[i].$1),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOut,
                                height: wide ? 160 : 120,
                                decoration: GameTheme.selectableCard(
                                  selected: value == options[i].$1,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      options[i].$3,
                                      size: 36,
                                      color: value == options[i].$1
                                          ? GameColors.primary
                                          : GameColors.textSecondary,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      options[i].$2,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: GameColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

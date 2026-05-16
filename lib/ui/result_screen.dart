import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_to_genui/quiz/quiz_models.dart';
import 'package:intro_to_genui/quiz/temperament_copy.dart';
import 'package:intro_to_genui/quiz/temperament_scoring.dart';
import 'package:intro_to_genui/ui/confetti_burst.dart';
import 'package:intro_to_genui/ui/floating_background.dart';
import 'package:intro_to_genui/ui/game_theme.dart';
import 'package:intro_to_genui/ui/responsive.dart';
import 'package:intro_to_genui/ui/route_paths.dart';
import 'package:intro_to_genui/ui/stagger_entry.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.breakdown});

  final TemperamentBreakdown breakdown;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  /// Re-key the confetti widget to retrigger the burst (e.g. on demand).
  int _confettiKey = 0;

  List<(TemperamentId, int)> get _sorted => [
        (TemperamentId.sanguine, widget.breakdown.sanguinePct),
        (TemperamentId.choleric, widget.breakdown.cholericPct),
        (TemperamentId.melancholic, widget.breakdown.melancholicPct),
        (TemperamentId.phlegmatic, widget.breakdown.phlegmaticPct),
      ]..sort((a, b) => b.$2.compareTo(a.$2));

  @override
  Widget build(BuildContext context) {
    final d = widget.breakdown.dominant;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          FloatingBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= Breakpoints.md;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? 48 : 20,
                      vertical: wide ? 40 : 20,
                    ),
                    child: CenteredContent(
                      maxWidth: 1100,
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ResultHeader(
                            onCelebrate: () => setState(() => _confettiKey++),
                          ),
                          SizedBox(height: wide ? 32 : 24),
                          StaggerEntry(
                            delay: const Duration(milliseconds: 220),
                            child: _DominantHeroCard(
                              temperament: d,
                              onCelebrate: () => setState(() => _confettiKey++),
                            ),
                          ),
                          SizedBox(height: wide ? 32 : 24),
                          if (wide)
                            _ResultBodyWide(dominant: d, sorted: _sorted)
                          else
                            _ResultBodyNarrow(dominant: d, sorted: _sorted),
                          SizedBox(height: wide ? 40 : 28),
                          StaggerEntry(
                            delay: const Duration(milliseconds: 900),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 420),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).popUntil((r) => r.isFirst);
                                          Navigator.of(context).pushNamed(RoutePaths.quiz);
                                        },
                                        icon: const Icon(Icons.replay_rounded, size: 18),
                                        label: const Text('Take the quiz again'),
                                        style: FilledButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).popUntil((r) => r.isFirst),
                                      child: Text(
                                        'Back to home',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: GameColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: ConfettiBurst(key: ValueKey<int>(_confettiKey)),
          ),
        ],
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.onCelebrate});

  final VoidCallback onCelebrate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StaggerEntry(
          child: Text(
            'YOUR RESULTS',
            style: GameTheme.eyebrow(color: GameColors.primary),
          ),
        ),
        const SizedBox(height: 8),
        StaggerEntry(
          delay: const Duration(milliseconds: 80),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text('You did it.', style: GameTheme.display(size: 40)),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                tooltip: 'Celebrate again',
                onPressed: onCelebrate,
                icon: const Icon(Icons.celebration_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        StaggerEntry(
          delay: const Duration(milliseconds: 140),
          child: Text(
            'Educational reflection only — not a clinical diagnosis.',
            style: GameTheme.body(size: 13),
          ),
        ),
      ],
    );
  }
}

class _ResultBodyWide extends StatelessWidget {
  const _ResultBodyWide({required this.dominant, required this.sorted});

  final TemperamentId dominant;
  final List<(TemperamentId, int)> sorted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StaggerEntry(
                delay: const Duration(milliseconds: 320),
                child: _SectionLabel(label: 'Your personality blend'),
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < sorted.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: StaggerEntry(
                    delay: Duration(milliseconds: 380 + i * 70),
                    child: _BlendRow(
                      temperament: sorted[i].$1,
                      percent: sorted[i].$2,
                      isDominant: sorted[i].$1 == dominant,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StaggerEntry(
                delay: const Duration(milliseconds: 500),
                child: _SectionLabel(label: 'Strengths & challenges'),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StaggerEntry(
                      delay: const Duration(milliseconds: 560),
                      child: _ListCard(
                        title: 'Strengths',
                        icon: Icons.star_rounded,
                        iconColor: GameColors.accent,
                        lines: TemperamentCopy.strengths(dominant),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: StaggerEntry(
                      delay: const Duration(milliseconds: 620),
                      child: _ListCard(
                        title: 'Challenges',
                        icon: Icons.flag_rounded,
                        iconColor: GameColors.rose,
                        lines: TemperamentCopy.challenges(dominant),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              StaggerEntry(
                delay: const Duration(milliseconds: 680),
                child: _SectionLabel(label: 'Ideas for you'),
              ),
              const SizedBox(height: 14),
              StaggerEntry(
                delay: const Duration(milliseconds: 720),
                child: _ListCard(
                  title: 'Careers to explore',
                  lines: TemperamentCopy.careers(dominant),
                ),
              ),
              const SizedBox(height: 12),
              StaggerEntry(
                delay: const Duration(milliseconds: 780),
                child: _ListCard(
                  title: 'Study styles',
                  lines: TemperamentCopy.studyStyles(dominant),
                ),
              ),
              const SizedBox(height: 12),
              StaggerEntry(
                delay: const Duration(milliseconds: 840),
                child: _ListCard(
                  title: 'Relationship tips',
                  lines: TemperamentCopy.relationshipTips(dominant),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultBodyNarrow extends StatelessWidget {
  const _ResultBodyNarrow({required this.dominant, required this.sorted});

  final TemperamentId dominant;
  final List<(TemperamentId, int)> sorted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StaggerEntry(
          delay: const Duration(milliseconds: 320),
          child: _SectionLabel(label: 'Your personality blend'),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < sorted.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: StaggerEntry(
              delay: Duration(milliseconds: 380 + i * 70),
              child: _BlendRow(
                temperament: sorted[i].$1,
                percent: sorted[i].$2,
                isDominant: sorted[i].$1 == dominant,
              ),
            ),
          ),
        const SizedBox(height: 20),
        StaggerEntry(
          delay: const Duration(milliseconds: 600),
          child: _SectionLabel(label: 'Strengths'),
        ),
        const SizedBox(height: 10),
        StaggerEntry(
          delay: const Duration(milliseconds: 640),
          child: _ListCard(
            icon: Icons.star_rounded,
            iconColor: GameColors.accent,
            lines: TemperamentCopy.strengths(dominant),
          ),
        ),
        const SizedBox(height: 14),
        StaggerEntry(
          delay: const Duration(milliseconds: 680),
          child: _SectionLabel(label: 'Challenges'),
        ),
        const SizedBox(height: 10),
        StaggerEntry(
          delay: const Duration(milliseconds: 720),
          child: _ListCard(
            icon: Icons.flag_rounded,
            iconColor: GameColors.rose,
            lines: TemperamentCopy.challenges(dominant),
          ),
        ),
        const SizedBox(height: 20),
        StaggerEntry(
          delay: const Duration(milliseconds: 760),
          child: _SectionLabel(label: 'Ideas for you'),
        ),
        const SizedBox(height: 10),
        StaggerEntry(
          delay: const Duration(milliseconds: 800),
          child: _ListCard(
            title: 'Careers to explore',
            lines: TemperamentCopy.careers(dominant),
          ),
        ),
        const SizedBox(height: 10),
        StaggerEntry(
          delay: const Duration(milliseconds: 840),
          child: _ListCard(
            title: 'Study styles',
            lines: TemperamentCopy.studyStyles(dominant),
          ),
        ),
        const SizedBox(height: 10),
        StaggerEntry(
          delay: const Duration(milliseconds: 880),
          child: _ListCard(
            title: 'Relationship tips',
            lines: TemperamentCopy.relationshipTips(dominant),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: GameTheme.heading(size: 18));
  }
}

class _DominantHeroCard extends StatelessWidget {
  const _DominantHeroCard({
    required this.temperament,
    required this.onCelebrate,
  });

  final TemperamentId temperament;
  final VoidCallback onCelebrate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [GameColors.primary, GameColors.violet, GameColors.rose],
        ),
        boxShadow: [
          BoxShadow(
            color: GameColors.primary.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 560;
          final emoji = Container(
            width: wide ? 96 : 72,
            height: wide ? 96 : 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(wide ? 24 : 20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            ),
            child: Text(
              temperament.emoji,
              style: TextStyle(fontSize: wide ? 48 : 36),
            ),
          );
          final info = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'YOUR DOMINANT TEMPERAMENT',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                temperament.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: wide ? 44 : 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.6,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                TemperamentCopy.tagline(temperament),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.95),
                  height: 1.55,
                ),
              ),
            ],
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                emoji,
                const SizedBox(width: 24),
                Expanded(child: info),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              emoji,
              const SizedBox(height: 16),
              info,
            ],
          );
        },
      ),
    );
  }
}

class _BlendRow extends StatelessWidget {
  const _BlendRow({
    required this.temperament,
    required this.percent,
    required this.isDominant,
  });

  final TemperamentId temperament;
  final int percent;
  final bool isDominant;

  Color get _color => switch (temperament) {
        TemperamentId.sanguine => GameColors.accent,
        TemperamentId.choleric => GameColors.rose,
        TemperamentId.melancholic => GameColors.violet,
        TemperamentId.phlegmatic => GameColors.sky,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: GameTheme.cleanCard(elevated: !isDominant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  temperament.emoji,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  temperament.label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: GameColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: GameColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: percent / 100),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) {
                return LinearProgressIndicator(
                  value: v,
                  minHeight: 10,
                  backgroundColor: GameColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(_color),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    this.title,
    this.icon,
    this.iconColor,
    required this.lines,
  });

  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: GameTheme.cleanCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: GameTheme.heading(size: 16)),
            const SizedBox(height: 12),
          ],
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, right: 10),
                      child: Icon(icon, size: 18, color: iconColor),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GameColors.textSecondary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      line,
                      style: GameTheme.body(
                        size: 14,
                        weight: FontWeight.w500,
                        color: GameColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

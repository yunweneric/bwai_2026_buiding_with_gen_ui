import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_to_genui/ui/floating_background.dart';
import 'package:intro_to_genui/ui/game_theme.dart';
import 'package:intro_to_genui/ui/responsive.dart';
import 'package:intro_to_genui/ui/route_paths.dart';
import 'package:intro_to_genui/ui/stagger_entry.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FloatingBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= Breakpoints.md;
              return CenteredContent(
                maxWidth: 1100,
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 48 : 24,
                  vertical: wide ? 56 : 28,
                ),
                child: wide ? const _HomeWide() : const _HomeNarrow(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeWide extends StatelessWidget {
  const _HomeWide();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Expanded(child: _HomeContent()),
          SizedBox(width: 48),
          Expanded(child: _HomeHeroCard()),
        ],
      ),
    );
  }
}

class _HomeNarrow extends StatelessWidget {
  const _HomeNarrow();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          SizedBox(
            height: 280,
            child: _HomeHeroCard(),
          ),
          SizedBox(height: 28),
          _HomeContent(),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        StaggerEntry(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: GameColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'TEMPERAMENT QUEST',
              style: GameTheme.eyebrow(color: GameColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 20),
        StaggerEntry(
          delay: const Duration(milliseconds: 100),
          child: Text(
            'Discover your\ntemperament blend.',
            style: GameTheme.display(size: 48),
          ),
        ),
        const SizedBox(height: 18),
        StaggerEntry(
          delay: const Duration(milliseconds: 180),
          child: Text(
            'Twenty short questions reveal how you mix the classic four — '
            'Sanguine, Choleric, Melancholic, and Phlegmatic. You\'ll see your '
            'dominant style plus a percentage breakdown of all four.',
            style: GameTheme.body(size: 16),
          ),
        ),
        const SizedBox(height: 24),
        StaggerEntry(
          delay: const Duration(milliseconds: 240),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _FeaturePill(icon: Icons.timer_outlined, label: '~3 minutes'),
              _FeaturePill(icon: Icons.swipe_outlined, label: 'Swipe between questions'),
              _FeaturePill(icon: Icons.insights_outlined, label: 'Full blend breakdown'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        StaggerEntry(
          delay: const Duration(milliseconds: 320),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(RoutePaths.quiz),
                icon: const Icon(Icons.play_arrow_rounded, size: 22),
                label: const Text('Start the quiz'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Educational reflection only.',
                style: GameTheme.body(size: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeHeroCard extends StatelessWidget {
  const _HomeHeroCard();

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [GameColors.primary, GameColors.violet, GameColors.rose],
        ),
        boxShadow: [
          BoxShadow(
            color: GameColors.primary.withValues(alpha: 0.35),
            blurRadius: 48,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 36,
            left: 32,
            child: _TempBadge(emoji: '🎉', label: 'Sanguine'),
          ),
          const Positioned(
            top: 80,
            right: 32,
            child: _TempBadge(emoji: '⚡', label: 'Choleric'),
          ),
          const Positioned(
            bottom: 80,
            left: 32,
            child: _TempBadge(emoji: '🌙', label: 'Melancholic'),
          ),
          const Positioned(
            bottom: 36,
            right: 32,
            child: _TempBadge(emoji: '🌊', label: 'Phlegmatic'),
          ),
          Center(
            child: Container(
              width: 132,
              height: 132,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: const Text('🎭', style: TextStyle(fontSize: 64)),
            ),
          ),
        ],
      ),
    );

    return StaggerEntry(
      delay: const Duration(milliseconds: 80),
      child: LayoutBuilder(
        builder: (context, c) {
          // When laid out inside an unbounded-height column (wide layout),
          // constrain the card to a 1:1 aspect ratio. When given a fixed
          // height (narrow scrollable column), let it fill that height.
          if (!c.hasBoundedHeight) {
            return AspectRatio(aspectRatio: 1, child: card);
          }
          return card;
        },
      ),
    );
  }
}

class _TempBadge extends StatelessWidget {
  const _TempBadge({required this.emoji, required this.label});

  final String emoji;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: GameColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: GameColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: GameColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: GameColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

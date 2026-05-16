import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_to_genui/catalog/temperament_catalog_id.dart';
import 'package:intro_to_genui/ui/game_theme.dart';
import 'package:intro_to_genui/ui/hover_lift.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// Merges the GenUI basic catalog with temperament-styled components so the
/// model can compose layouts while controls match the pre-GenUI look.
Catalog temperamentQuestCatalog() {
  final base = BasicCatalogItems.asCatalog();
  return Catalog(
    [
      ...base.items,
      temperamentOptionGrid,
      temperamentYesNoRow,
      temperamentScaleRow,
      temperamentRoutineToggle,
    ],
    functions: base.functions,
    catalogId: kTemperamentQuestCatalogId,
    systemPromptFragments: const [
      'Temperament quest components (prefer these for questions): '
      'TemperamentOptionGrid (multi choice / cards), TemperamentYesNoRow, '
      'TemperamentScaleRow (integer steps), TemperamentRoutineToggle. '
      'Bind answers with `"value": {"path": "/answer"}` on each input. '
      'Compose prompts with Column + Text as needed.',
    ],
  );
}

final _optionGridSchema = S.object(
  description:
      'Responsive card or chip grid for one-of-many answers. Writes a list '
      'of one string id to /answer.',
  properties: {
    'options': S.list(
      items: S.object(
        properties: {
          'id': S.string(),
          'label': S.string(),
          'emoji': S.string(),
        },
        required: ['id', 'label'],
      ),
    ),
    'value': S.object(
      properties: {'path': S.string()},
      required: ['path'],
    ),
    'chipStyle': S.boolean(),
    'maxColumns': S.number(),
  },
  required: ['options', 'value'],
);

extension type _OptionGridData.fromMap(JsonMap _m) {
  List<JsonMap> get options => (_m['options'] as List?)?.cast<JsonMap>() ?? [];
  Object get value => _m['value'] as Object;
  bool get chipStyle => _m['chipStyle'] as bool? ?? false;
  int get maxColumns => (_m['maxColumns'] as num?)?.round().clamp(1, 4) ?? 4;
}

final CatalogItem temperamentOptionGrid = CatalogItem(
  name: 'TemperamentOptionGrid',
  dataSchema: _optionGridSchema,
  widgetBuilder: (ctx) {
    final d = _OptionGridData.fromMap(ctx.data as JsonMap);
    final path = (d.value is Map && (d.value as Map)['path'] is String)
        ? (d.value as Map)['path'] as String
        : '/answer';
    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth >= 1000
            ? d.maxColumns
            : c.maxWidth >= 640
            ? 2
            : 2;
        final gap = 16.0;
        final w = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < d.options.length; i++)
              SizedBox(
                width: w,
                child: _OptionTile(
                  option: d.options[i],
                  chipStyle: d.chipStyle,
                  path: path,
                  ctx: ctx,
                ),
              ),
          ],
        );
      },
    );
  },
);

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.chipStyle,
    required this.path,
    required this.ctx,
  });

  final JsonMap option;
  final bool chipStyle;
  final String path;
  final CatalogItemContext ctx;

  @override
  Widget build(BuildContext context) {
    final id = option['id']! as String;
    final label = option['label']! as String;
    final emoji = option['emoji'] as String?;
    return BoundObject(
      dataContext: ctx.dataContext,
      value: {'path': path},
      builder: (context, cur) {
        String? selected;
        if (cur is List && cur.isNotEmpty) {
          selected = cur.first.toString();
        } else if (cur is String) {
          selected = cur;
        }
        final sel = selected == id;
        final child = Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () =>
                ctx.dataContext.update(DataPath(path), <String>[id]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(20),
              decoration: GameTheme.selectableCard(selected: sel),
              child: chipStyle
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (emoji != null) ...[
                          Text(emoji, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (emoji != null)
                              Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: sel
                                      ? GameColors.primary.withValues(alpha: 0.1)
                                      : GameColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(emoji, style: const TextStyle(fontSize: 26)),
                              ),
                            AnimatedScale(
                              duration: const Duration(milliseconds: 200),
                              scale: sel ? 1 : 0,
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: GameColors.primary,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
        return HoverLift(child: child);
      },
    );
  }
}

final _yesNoSchema = S.object(
  description: 'Side-by-side Yes / No cards. Writes ["yes"] or ["no"] to /answer.',
  properties: {
    'value': S.object(
      properties: {'path': S.string()},
      required: ['path'],
    ),
  },
  required: ['value'],
);

final CatalogItem temperamentYesNoRow = CatalogItem(
  name: 'TemperamentYesNoRow',
  dataSchema: _yesNoSchema,
  widgetBuilder: (ctx) {
    final m = ctx.data as JsonMap;
    final path = ((m['value'] as Map)['path'] as String?) ?? '/answer';
    Widget cell(String id, String label, String emoji, Color accent) {
      return Expanded(
        child: BoundObject(
          dataContext: ctx.dataContext,
          value: {'path': path},
          builder: (context, cur) {
            final sel = _firstString(cur) == id;
            return HoverLift(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () =>
                      ctx.dataContext.update(DataPath(path), <String>[id]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 180,
                    decoration: GameTheme.selectableCard(
                      selected: sel,
                      accent: accent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 44)),
                        const SizedBox(height: 12),
                        Text(
                          label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Row(
      children: [
        cell('yes', 'Yes', '✅', GameColors.success),
        const SizedBox(width: 16),
        cell('no', 'No', '➡️', GameColors.danger),
      ],
    );
  },
);

String? _firstString(Object? cur) {
  if (cur is List && cur.isNotEmpty) return cur.first.toString();
  if (cur is String) return cur;
  return null;
}

final _scaleSchema = S.object(
  description: 'Horizontal 1..N step control (like the static quiz). '
      'Writes an integer to /answer.',
  properties: {
    'min': S.number(),
    'max': S.number(),
    'tickLabels': S.list(items: S.string()),
    'value': S.object(
      properties: {'path': S.string()},
      required: ['path'],
    ),
  },
  required: ['min', 'max', 'value'],
);

final CatalogItem temperamentScaleRow = CatalogItem(
  name: 'TemperamentScaleRow',
  dataSchema: _scaleSchema,
  widgetBuilder: (ctx) {
    final m = ctx.data as JsonMap;
    final min = (m['min'] as num?)?.round() ?? 0;
    final max = (m['max'] as num?)?.round() ?? 4;
    final ticks = (m['tickLabels'] as List?)?.cast<String>() ?? const <String>[];
    final path = ((m['value'] as Map)['path'] as String?) ?? '/answer';
    return BoundObject(
      dataContext: ctx.dataContext,
      value: {'path': path},
      builder: (context, cur) {
        final v = cur is num ? cur.round() : (cur is int ? cur : null);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                for (var i = min; i <= max; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: i == min ? 0 : 6,
                        right: i == max ? 0 : 6,
                      ),
                      child: HoverLift(
                        scale: 1.04,
                        lift: 2,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () =>
                                ctx.dataContext.update(DataPath(path), i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              height: 72,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: v == i
                                    ? GameColors.primary
                                    : GameColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: v == i
                                      ? GameColors.primary
                                      : GameColors.border,
                                  width: v == i ? 2 : 1,
                                ),
                                boxShadow: v == i
                                    ? [
                                        BoxShadow(
                                          color: GameColors.primary.withValues(
                                            alpha: 0.28,
                                          ),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                '${i - min + 1}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: v == i ? Colors.white : GameColors.textPrimary,
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
            if (ticks.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                v != null && v - min < ticks.length
                    ? ticks[v - min]
                    : 'Pick a value',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: GameColors.primaryDark,
                ),
              ),
            ],
          ],
        );
      },
    );
  },
);

final _toggleSchema = S.object(
  description: 'Routine vs spontaneity pair cards. Writes ["routine"] or '
      '["spontaneity"] to /answer.',
  properties: {
    'leftLabel': S.string(),
    'rightLabel': S.string(),
    'value': S.object(
      properties: {'path': S.string()},
      required: ['path'],
    ),
  },
  required: ['value'],
);

final CatalogItem temperamentRoutineToggle = CatalogItem(
  name: 'TemperamentRoutineToggle',
  dataSchema: _toggleSchema,
  widgetBuilder: (ctx) {
    final m = ctx.data as JsonMap;
    final left = m['leftLabel'] as String? ?? 'Routine';
    final right = m['rightLabel'] as String? ?? 'Spontaneity';
    final path = ((m['value'] as Map)['path'] as String?) ?? '/answer';
    Widget side(String id, String label, IconData icon) {
      return Expanded(
        child: BoundObject(
          dataContext: ctx.dataContext,
          value: {'path': path},
          builder: (context, cur) {
            final sel = _firstString(cur) == id;
            return HoverLift(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () =>
                      ctx.dataContext.update(DataPath(path), <String>[id]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 160,
                    decoration: GameTheme.selectableCard(selected: sel),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 36,
                          color: sel ? GameColors.primary : GameColors.textSecondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Row(
      children: [
        side('routine', left, Icons.calendar_today_rounded),
        const SizedBox(width: 16),
        side('spontaneity', right, Icons.bolt_rounded),
      ],
    );
  },
);

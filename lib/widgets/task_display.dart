import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:intro_to_genui/theme/app_theme.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final taskDisplaySchema = S.object(
  properties: {
    'component': S.string(enumValues: ['TaskDisplay']),
    'title': S.string(description: 'The title of the task list'),
    'tasks': S.list(
      description: 'A list of tasks to be completed today',
      items: S.object(
        properties: {
          'name': S.string(description: 'The name of the task to be completed'),
          'isCompleted': S.boolean(description: 'Whether the task is completed'),
          'completeAction': A2uiSchemas.action(
            description: 'The action performed when the user has completed the task.',
          ),
        },
        required: ['name', 'isCompleted', 'completeAction'],
      ),
    ),
  },
  required: ['title', 'tasks'],
);

class _TaskData {
  final String name;
  final bool isCompleted;
  final String actionName;
  final JsonMap actionContext;

  _TaskData({
    required this.name,
    required this.isCompleted,
    required this.actionName,
    required this.actionContext,
  });

  factory _TaskData.fromJson(Map<String, Object?> json) {
    try {
      final action = json['completeAction']! as JsonMap;
      final event = action['event']! as JsonMap;

      return _TaskData(
        name: json['name'] as String,
        isCompleted: json['isCompleted'] as bool,
        actionName: event['name'] as String,
        actionContext: event['context'] as JsonMap,
      );
    } catch (e) {
      throw Exception('Invalid JSON for _TaskData: $e');
    }
  }
}

class _TaskDisplayData {
  final String title;
  final List<_TaskData> tasks;

  _TaskDisplayData({required this.title, required this.tasks});

  factory _TaskDisplayData.fromJson(Map<String, Object?> json) {
    try {
      return _TaskDisplayData(
        title: (json['title'] as String?) ?? 'Today',
        tasks: (json['tasks'] as List<Object?>)
            .map((e) => _TaskData.fromJson(e as Map<String, Object?>))
            .toList(),
      );
    } catch (e) {
      throw Exception('Invalid JSON for _TaskDisplayData: $e');
    }
  }

  int get completedCount => tasks.where((t) => t.isCompleted).length;
}

class _TaskDisplay extends StatelessWidget {
  final _TaskDisplayData data;
  final void Function(_TaskData) onCompleteTask;

  const _TaskDisplay({required this.data, required this.onCompleteTask});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = data.tasks.length;
    final completed = data.completedCount;
    final progress = total == 0 ? 0.0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (total > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$completed of $total completed',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            if (total > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: completed == total
                      ? AppColors.successMuted
                      : AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  completed == total ? 'Done' : '${(progress * 100).round()}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: completed == total
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
        if (total > 0) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.borderSubtle,
              color: completed == total ? AppColors.success : AppColors.primary,
            ),
          ),
        ],
        if (data.tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Your tasks will appear here once you agree on a plan.',
              style: theme.textTheme.bodyMedium,
            ),
          )
        else ...[
          const SizedBox(height: 16),
          for (var i = 0; i < data.tasks.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.borderSubtle),
            _TaskRow(
              task: data.tasks[i],
              onComplete: () => onCompleteTask(data.tasks[i]),
            ),
          ],
        ],
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task, required this.onComplete});

  final _TaskData task;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: task.isCompleted ? null : onComplete,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              _TaskCheckbox(isCompleted: task.isCompleted),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: task.isCompleted
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCheckbox extends StatelessWidget {
  const _TaskCheckbox({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.success : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isCompleted ? AppColors.success : AppColors.border,
          width: 1.5,
        ),
      ),
      child: isCompleted
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : null,
    );
  }
}

final taskDisplay = CatalogItem(
  name: 'TaskDisplay',
  dataSchema: taskDisplaySchema,
  widgetBuilder: (itemContext) {
    final json = itemContext.data as Map<String, Object?>;
    final data = _TaskDisplayData.fromJson(json);

    return _TaskDisplay(
      data: data,
      onCompleteTask: (task) async {
        final JsonMap resolvedContext = await resolveContext(
          itemContext.dataContext,
          task.actionContext,
        );

        itemContext.dispatchEvent(
          UserActionEvent(
            name: task.actionName,
            sourceComponentId: itemContext.id,
            context: resolvedContext,
          ),
        );
      },
    );
  },
);

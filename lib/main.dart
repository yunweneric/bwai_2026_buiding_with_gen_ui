import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:intro_to_genui/ui/game_theme.dart';
import 'package:intro_to_genui/ui/home_screen.dart';
import 'package:intro_to_genui/ui/quiz_flow_screen.dart';
import 'package:intro_to_genui/ui/route_paths.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TemperamentQuestApp());
}

class TemperamentQuestApp extends StatelessWidget {
  const TemperamentQuestApp({super.key, this.quizTransport});

  /// Injected for tests; when null the quiz reads compile-time defines from
  /// `--dart-define` / `--dart-define-from-file` (e.g. project `env.json` via
  /// `.vscode/launch.json`).
  final Transport? quizTransport;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperament Quest',
      theme: GameTheme.theme(),
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePaths.home,
      routes: {
        RoutePaths.home: (_) => const HomeScreen(),
        RoutePaths.quiz: (_) => QuizFlowScreen(transport: quizTransport),
      },
    );
  }
}

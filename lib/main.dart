import 'package:flutter/material.dart';
import 'package:intro_to_genui/ui/game_theme.dart';
import 'package:intro_to_genui/ui/home_screen.dart';
import 'package:intro_to_genui/ui/quiz_flow_screen.dart';
import 'package:intro_to_genui/ui/route_paths.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TemperamentQuestApp());
}

class TemperamentQuestApp extends StatelessWidget {
  const TemperamentQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperament Quest',
      theme: GameTheme.theme(),
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePaths.home,
      routes: {
        RoutePaths.home: (_) => const HomeScreen(),
        RoutePaths.quiz: (_) => const QuizFlowScreen(),
      },
    );
  }
}

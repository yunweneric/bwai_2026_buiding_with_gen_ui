import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart' as gemini;
import 'package:intro_to_genui/theme/app_theme.dart';

const _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
const _geminiModelRaw = String.fromEnvironment(
  'GEMINI_MODEL',
  defaultValue: 'gemini-2.0-flash',
);

String get _geminiModel =>
    _geminiModelRaw.startsWith('models/') ? _geminiModelRaw : 'models/$_geminiModelRaw';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_geminiApiKey.isEmpty) {
    throw StateError(
      'GEMINI_API_KEY is not set. Copy env.json.example to env.json and run with:\n'
      'flutter run -d chrome --dart-define-from-file=env.json',
    );
  }

  gemini.Gemini.init(apiKey: _geminiApiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Today',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: const _WorkshopSetupHome(),
    );
  }
}

/// Workshop step 1 — dependencies and `flutter_gemini` bootstrap only.
class _WorkshopSetupHome extends StatelessWidget {
  const _WorkshopSetupHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Just Today — setup')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Gemini is initialized with your API key from '
              'GEMINI_API_KEY (via env.json or --dart-define). '
              'Next branch adds the chat UI.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

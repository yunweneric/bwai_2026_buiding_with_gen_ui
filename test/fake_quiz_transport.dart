import 'dart:async';
import 'dart:convert';

import 'package:genui/genui.dart';
import 'package:intro_to_genui/catalog/temperament_catalog_id.dart';

/// Deterministic [Transport] for widget tests (no network).
class FakeQuizTransport implements Transport {
  FakeQuizTransport();

  final A2uiTransportAdapter _adapter = A2uiTransportAdapter();

  @override
  Stream<String> get incomingText => _adapter.incomingText;

  @override
  Stream<A2uiMessage> get incomingMessages => _adapter.incomingMessages;

  @override
  Future<void> sendRequest(ChatMessage message) async {
    await Future<void>.delayed(Duration.zero);
    final create = jsonEncode({
      'version': 'v0.9',
      'createSurface': {
        'surfaceId': 'q1',
        'catalogId': kTemperamentQuestCatalogId,
        'sendDataModel': true,
      },
    });
    final update = jsonEncode({
      'version': 'v0.9',
      'updateComponents': {
        'surfaceId': 'q1',
        'components': [
          {
            'id': 'root',
            'component': 'Column',
            'justify': 'start',
            'children': ['t1'],
          },
          {
            'id': 't1',
            'component': 'Text',
            'text': 'Mock question',
            'variant': 'h3',
          },
        ],
      },
    });
    _adapter.addChunk(create);
    _adapter.addChunk(update);
  }

  @override
  void dispose() {
    _adapter.dispose();
  }
}

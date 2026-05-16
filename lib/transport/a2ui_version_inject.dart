import 'dart:convert';

/// Returns the index after the closing `}` of a balanced `{...}` starting at
/// [openBrace], respecting double-quoted strings and escapes.
int? _endOfBalancedJsonObject(String s, int openBrace) {
  if (openBrace >= s.length || s[openBrace] != '{') {
    return null;
  }
  var depth = 1;
  var inString = false;
  var escaped = false;
  for (var i = openBrace + 1; i < s.length; i++) {
    final ch = s[i];
    if (inString) {
      if (escaped) {
        escaped = false;
        continue;
      }
      if (ch == r'\') {
        escaped = true;
        continue;
      }
      if (ch == '"') {
        inString = false;
      }
      continue;
    }
    if (ch == '"') {
      inString = true;
      continue;
    }
    if (ch == '{') {
      depth++;
    } else if (ch == '}') {
      depth--;
      if (depth == 0) {
        return i + 1;
      }
    }
  }
  return null;
}

const _a2uiTopLevelKeys = {
  'createSurface',
  'updateComponents',
  'updateDataModel',
  'deleteSurface',
};

/// Gemini often omits the required `"version":"v0.9"` wrapper. GenUI rejects
/// those payloads; this prepends the version field when it is missing.
String ensureA2uiVersionOnJsonObjects(String text) {
  final out = StringBuffer();
  var i = 0;
  while (i < text.length) {
    final start = text.indexOf('{', i);
    if (start == -1) {
      out.write(text.substring(i));
      break;
    }
    out.write(text.substring(i, start));
    final end = _endOfBalancedJsonObject(text, start);
    if (end == null) {
      out.write(text.substring(start));
      break;
    }
    final raw = text.substring(start, end);
    i = end;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final m = Map<String, Object?>.from(decoded);
        if (!m.containsKey('version') &&
            m.keys.any(_a2uiTopLevelKeys.contains)) {
          m['version'] = 'v0.9';
          out.write(jsonEncode(m));
          continue;
        }
      }
    } on FormatException {
      // leave raw fragment as-is
    }
    out.write(raw);
  }
  return out.toString();
}

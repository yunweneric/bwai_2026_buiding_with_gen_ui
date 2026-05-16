---

## marp: true
theme: default
paginate: true
size: 16:9
footer: "intro_to_genui · BWAI Gemini × GenUI workshop"
style: |
  section { font-size: 28px; }
  h1 { font-size: 40px; }
  code { font-size: 22px; }



# Just Today — GenUI without Firebase

## `**bwai_gemini/01**` — Bootstrap

- Add `**flutter_gemini**`; no `firebase_core` / `firebase_ai`.
- `**Gemini.init(apiKey: …)**` with keys from `**--dart-define-from-file=env.json**` (`GEMINI_API_KEY`, optional `GEMINI_MODEL`).
- Shared `**AppTheme**`; this step is **API + theme only** — no chat UI yet.

```bash
git checkout bwai_gemini/01
flutter pub get
flutter run -d chrome --dart-define-from-file=env.json
```

---

# `**bwai_gemini/02**` — Plain Gemini chat

- `**List<gemini.Content>**` holds multi-turn history (user / model roles).
- `**Gemini.instance.chat(history, systemPrompt: …, modelName: …)**` returns assistant text.
- `**MessageBubble**` + `ListView`; still **no GenUI** — baseline before surfaces.

```bash
git checkout bwai_gemini/02
```

---

# `**bwai_gemini/03**` — GenUI + Gemini transport

- `**Conversation**`, `**SurfaceController**`, `**A2uiTransportAdapter(onSend: _sendAndReceive)**`.
- `**_sendAndReceive**`: skip `**ChatMessageRole.system**`; serialize parts (UI + `**genui.TextPart**`); append user turn → **Gemini** → `**_transport.addChunk(output)`**.
- `**PromptBuilder.chat**` builds `**_systemPrompt**` (catalog schema in the system string).
- Post-frame `**ChatMessage.user('Start our session.')**` kicks the first agent turn.

```bash
git checkout bwai_gemini/03
```

---

# `**bwai_gemini/04**` — Waiting state

- `**ValueListenableBuilder<ConversationState>**` on `**_conversation.state**`.
- Disable send / `**onSubmitted**` while `**state.isWaiting**`.
- `**Stack**` + top `**LinearProgressIndicator**` while the model streams GenUI / text.

```bash
git checkout bwai_gemini/04
```

---

# `**bwai_gemini/05**` — Pin the task surface

- Constant `**taskDisplaySurfaceId**` (e.g. `**task_display**`).
- `**ConversationSurfaceAdded**`: do **not** push that id into the scrolling list — render it **only** in the header slot.
- Prompt gains `**## USER INTERFACE`** (TaskDisplay, reuse one surface id, brief text).

```bash
git checkout bwai_gemini/05
```

---

# `**bwai_gemini/06**` — `TaskDisplay` catalog item

- `**json_schema_builder**`: schema + `**A2uiSchemas.action**` for `**completeAction**`.
- `**CatalogItem**` → `**resolveContext**` + `**UserActionEvent**` on complete.
- `**BasicCatalogItems.asCatalog().copyWith(newItems: [taskDisplay])**` registers the widget.

```bash
git checkout bwai_gemini/06
```

---

# `**bwai_gemini/07**` — Milestone (no code delta)

- **Empty git checkpoint** after catalog wiring — good tag for **hot restart** demos.
- Same runtime behavior as `**bwai_gemini/06`**; use it to **reset the room** between cohorts.

```bash
git checkout bwai_gemini/07
```

---

# `**bwai_gemini/08**` — Experiment & recap

- **Empty checkpoint** — time for **natural language + UI** exercises (edit list, bulk complete, etc.).
- **Recap**: BYO model = `**flutter_gemini`** + history; GenUI = **surfaces + catalog + actions**; branches `**bwai_gemini/01`…`08`** replay the whole path.

**Reference codelab:** [genui-intro](https://codelabs.developers.google.com/codelabs/genui-intro?hl=en)

```bash
git checkout bwai_gemini/08
```


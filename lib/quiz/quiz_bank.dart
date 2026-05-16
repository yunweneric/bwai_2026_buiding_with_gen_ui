import 'quiz_models.dart';

/// All 20 temperament questions with scoring weights (higher = stronger pull).
List<QuizQuestion> loadQuizQuestions() => [
      // 1 — Select cards
      QuizQuestion(
        index: 1,
        prompt: 'How do you usually feel in large social gatherings?',
        subtitle: 'Pick the vibe that fits you best',
        kind: QuestionInputKind.selectCards,
        options: [
          QuizOption(
            id: '1a',
            label: 'Excited and energized',
            emoji: '✨',
            weights: TemperamentWeights(sanguine: 4, choleric: 1, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '1b',
            label: 'Comfortable but reserved',
            emoji: '🙂',
            weights: TemperamentWeights(sanguine: 1, choleric: 0, melancholic: 1, phlegmatic: 3),
          ),
          QuizOption(
            id: '1c',
            label: 'Observing quietly',
            emoji: '👀',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 3, phlegmatic: 2),
          ),
          QuizOption(
            id: '1d',
            label: 'Prefer avoiding them',
            emoji: '🏠',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 2, phlegmatic: 4),
          ),
        ],
      ),
      // 2 — Radio
      QuizQuestion(
        index: 2,
        prompt: 'In group projects, what role do you naturally take?',
        kind: QuestionInputKind.radioButtons,
        options: [
          QuizOption(
            id: '2a',
            label: 'Leader / Organizer',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '2b',
            label: 'Motivator',
            weights: TemperamentWeights(sanguine: 4, choleric: 1, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '2c',
            label: 'Planner / Researcher',
            weights: TemperamentWeights(sanguine: 0, choleric: 1, melancholic: 4, phlegmatic: 1),
          ),
          QuizOption(
            id: '2d',
            label: 'Supporter / Mediator',
            weights: TemperamentWeights(sanguine: 1, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
        ],
      ),
      // 3 — Yes / No cards
      QuizQuestion(
        index: 3,
        prompt: 'Do you often think deeply about past conversations or events?',
        kind: QuestionInputKind.yesNoCards,
        options: [
          QuizOption(
            id: 'yes',
            label: 'Yes',
            emoji: '✅',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 4, phlegmatic: 1),
          ),
          QuizOption(
            id: 'no',
            label: 'No',
            emoji: '➡️',
            weights: TemperamentWeights(sanguine: 2, choleric: 2, melancholic: 0, phlegmatic: 1),
          ),
        ],
      ),
      // 4 — Radio buttons
      QuizQuestion(
        index: 4,
        prompt: 'How do you respond when someone disagrees with you?',
        kind: QuestionInputKind.radioButtons,
        options: [
          QuizOption(
            id: '4a',
            label: 'Defend my opinion strongly',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 1, phlegmatic: 0),
          ),
          QuizOption(
            id: '4b',
            label: 'Stay calm and listen',
            weights: TemperamentWeights(sanguine: 1, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
          QuizOption(
            id: '4c',
            label: 'Feel personally affected',
            weights: TemperamentWeights(sanguine: 1, choleric: 0, melancholic: 4, phlegmatic: 1),
          ),
          QuizOption(
            id: '4d',
            label: 'Try to avoid conflict',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
        ],
      ),
      // 5 — Image choice (emoji tiles)
      QuizQuestion(
        index: 5,
        prompt: 'Which activity sounds most enjoyable to you?',
        kind: QuestionInputKind.imageChoiceCards,
        options: [
          QuizOption(
            id: '5a',
            label: 'Party with friends',
            emoji: '🎊',
            weights: TemperamentWeights(sanguine: 4, choleric: 1, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '5b',
            label: 'Leading a team activity',
            emoji: '🎯',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '5c',
            label: 'Reading or creating art',
            emoji: '📚',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 4, phlegmatic: 1),
          ),
          QuizOption(
            id: '5d',
            label: 'Relaxing in nature',
            emoji: '🌿',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
        ],
      ),
      // 6 — Slider slow → fast
      QuizQuestion(
        index: 6,
        prompt: 'How quickly do you make decisions?',
        kind: QuestionInputKind.sliderSlowFast,
        sliderSteps: [
          SliderStep(
            label: 'Very slowly',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 4, phlegmatic: 2),
          ),
          SliderStep(
            label: 'Slowly',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 3, phlegmatic: 3),
          ),
          SliderStep(
            label: 'Balanced',
            weights: TemperamentWeights(sanguine: 1, choleric: 1, melancholic: 1, phlegmatic: 2),
          ),
          SliderStep(
            label: 'Quickly',
            weights: TemperamentWeights(sanguine: 2, choleric: 3, melancholic: 0, phlegmatic: 0),
          ),
          SliderStep(
            label: 'Very quickly',
            weights: TemperamentWeights(sanguine: 2, choleric: 4, melancholic: 0, phlegmatic: 0),
          ),
        ],
      ),
      // 7 — Yes / No
      QuizQuestion(
        index: 7,
        prompt: 'Do you enjoy being the center of attention?',
        kind: QuestionInputKind.yesNoCards,
        options: [
          QuizOption(
            id: 'yes',
            label: 'Yes',
            emoji: '🌟',
            weights: TemperamentWeights(sanguine: 4, choleric: 2, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: 'no',
            label: 'No',
            emoji: '🫥',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 2, phlegmatic: 3),
          ),
        ],
      ),
      // 8 — Slider 1–5 organized
      QuizQuestion(
        index: 8,
        prompt: 'How organized are you in your daily life?',
        subtitle: '1 = not organized · 5 = extremely organized',
        kind: QuestionInputKind.slider1to5,
        sliderSteps: [
          SliderStep(
            label: '1 · Not organized',
            weights: TemperamentWeights(sanguine: 3, choleric: 1, melancholic: 0, phlegmatic: 0),
          ),
          SliderStep(
            label: '2',
            weights: TemperamentWeights(sanguine: 2, choleric: 1, melancholic: 1, phlegmatic: 1),
          ),
          SliderStep(
            label: '3',
            weights: TemperamentWeights(sanguine: 1, choleric: 1, melancholic: 1, phlegmatic: 2),
          ),
          SliderStep(
            label: '4',
            weights: TemperamentWeights(sanguine: 0, choleric: 2, melancholic: 2, phlegmatic: 1),
          ),
          SliderStep(
            label: '5 · Extremely organized',
            weights: TemperamentWeights(sanguine: 0, choleric: 2, melancholic: 3, phlegmatic: 2),
          ),
        ],
      ),
      // 9 — Select cards
      QuizQuestion(
        index: 9,
        prompt: 'What matters most to you in friendships?',
        kind: QuestionInputKind.selectCards,
        options: [
          QuizOption(
            id: '9a',
            label: 'Fun and excitement',
            emoji: '🎈',
            weights: TemperamentWeights(sanguine: 4, choleric: 1, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '9b',
            label: 'Loyalty and trust',
            emoji: '🤝',
            weights: TemperamentWeights(sanguine: 1, choleric: 2, melancholic: 2, phlegmatic: 2),
          ),
          QuizOption(
            id: '9c',
            label: 'Deep emotional connection',
            emoji: '💜',
            weights: TemperamentWeights(sanguine: 1, choleric: 0, melancholic: 4, phlegmatic: 1),
          ),
          QuizOption(
            id: '9d',
            label: 'Peace and stability',
            emoji: '☮️',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
        ],
      ),
      // 10 — Radio
      QuizQuestion(
        index: 10,
        prompt: 'How do you react under pressure?',
        kind: QuestionInputKind.radioButtons,
        options: [
          QuizOption(
            id: '10a',
            label: 'Take charge immediately',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '10b',
            label: 'Stay calm and steady',
            weights: TemperamentWeights(sanguine: 0, choleric: 1, melancholic: 1, phlegmatic: 4),
          ),
          QuizOption(
            id: '10c',
            label: 'Overthink situations',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 4, phlegmatic: 1),
          ),
          QuizOption(
            id: '10d',
            label: 'Seek support from others',
            weights: TemperamentWeights(sanguine: 3, choleric: 0, melancholic: 1, phlegmatic: 1),
          ),
        ],
      ),
      // 11 — Toggle routine vs spontaneity
      QuizQuestion(
        index: 11,
        prompt: 'Do you prefer routine or spontaneity?',
        kind: QuestionInputKind.toggleRoutineSpontaneity,
        toggleLeftLabel: 'Routine',
        toggleRightLabel: 'Spontaneity',
        toggleLeftWeights: TemperamentWeights(sanguine: 0, choleric: 1, melancholic: 2, phlegmatic: 4),
        toggleRightWeights: TemperamentWeights(sanguine: 4, choleric: 2, melancholic: 0, phlegmatic: 0),
      ),
      // 12 — Slider forgive
      QuizQuestion(
        index: 12,
        prompt: 'How easily do you forgive people?',
        subtitle: '1 = very difficult · 5 = very easy',
        kind: QuestionInputKind.slider1to5,
        sliderSteps: [
          SliderStep(
            label: '1 · Very difficult',
            weights: TemperamentWeights(sanguine: 0, choleric: 3, melancholic: 3, phlegmatic: 0),
          ),
          SliderStep(label: '2', weights: TemperamentWeights(sanguine: 0, choleric: 2, melancholic: 3, phlegmatic: 1)),
          SliderStep(label: '3', weights: TemperamentWeights(sanguine: 1, choleric: 1, melancholic: 2, phlegmatic: 2)),
          SliderStep(label: '4', weights: TemperamentWeights(sanguine: 2, choleric: 1, melancholic: 1, phlegmatic: 3)),
          SliderStep(
            label: '5 · Very easy',
            weights: TemperamentWeights(sanguine: 2, choleric: 0, melancholic: 0, phlegmatic: 4),
          ),
        ],
      ),
      // 13 — Select cards
      QuizQuestion(
        index: 13,
        prompt: 'What best describes your communication style?',
        kind: QuestionInputKind.selectCards,
        options: [
          QuizOption(
            id: '13a',
            label: 'Energetic and expressive',
            emoji: '🎤',
            weights: TemperamentWeights(sanguine: 4, choleric: 1, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '13b',
            label: 'Direct and confident',
            emoji: '📣',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '13c',
            label: 'Thoughtful and careful',
            emoji: '🧠',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 4, phlegmatic: 1),
          ),
          QuizOption(
            id: '13d',
            label: 'Calm and gentle',
            emoji: '🫶',
            weights: TemperamentWeights(sanguine: 1, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
        ],
      ),
      // 14 — Radio
      QuizQuestion(
        index: 14,
        prompt: 'When starting a new task, what motivates you most?',
        kind: QuestionInputKind.radioButtons,
        options: [
          QuizOption(
            id: '14a',
            label: 'Recognition',
            weights: TemperamentWeights(sanguine: 4, choleric: 2, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '14b',
            label: 'Achievement',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 1, phlegmatic: 0),
          ),
          QuizOption(
            id: '14c',
            label: 'Perfection',
            weights: TemperamentWeights(sanguine: 0, choleric: 1, melancholic: 4, phlegmatic: 1),
          ),
          QuizOption(
            id: '14d',
            label: 'Harmony',
            weights: TemperamentWeights(sanguine: 1, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
        ],
      ),
      // 15 — Slider worry mistakes
      QuizQuestion(
        index: 15,
        prompt: 'How often do you worry about making mistakes?',
        subtitle: '1 = rarely · 5 = constantly',
        kind: QuestionInputKind.slider1to5,
        sliderSteps: [
          SliderStep(
            label: '1 · Rarely',
            weights: TemperamentWeights(sanguine: 2, choleric: 2, melancholic: 0, phlegmatic: 2),
          ),
          SliderStep(label: '2', weights: TemperamentWeights(sanguine: 1, choleric: 1, melancholic: 2, phlegmatic: 2)),
          SliderStep(label: '3', weights: TemperamentWeights(sanguine: 0, choleric: 1, melancholic: 3, phlegmatic: 2)),
          SliderStep(label: '4', weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 4, phlegmatic: 1)),
          SliderStep(
            label: '5 · Constantly',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 4, phlegmatic: 1),
          ),
        ],
      ),
      // 16 — Image choice environment
      QuizQuestion(
        index: 16,
        prompt: 'What type of environment helps you feel most comfortable?',
        kind: QuestionInputKind.imageChoiceCards,
        options: [
          QuizOption(
            id: '16a',
            label: 'Social and lively',
            emoji: '👯',
            weights: TemperamentWeights(sanguine: 4, choleric: 1, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '16b',
            label: 'Competitive and active',
            emoji: '🏆',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '16c',
            label: 'Quiet and organized',
            emoji: '📐',
            weights: TemperamentWeights(sanguine: 0, choleric: 1, melancholic: 3, phlegmatic: 2),
          ),
          QuizOption(
            id: '16d',
            label: 'Peaceful and relaxed',
            emoji: '🛋️',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
        ],
      ),
      // 17 — Yes / No emotions
      QuizQuestion(
        index: 17,
        prompt: 'Do you usually express your emotions openly?',
        kind: QuestionInputKind.yesNoCards,
        options: [
          QuizOption(
            id: 'yes',
            label: 'Yes',
            emoji: '💬',
            weights: TemperamentWeights(sanguine: 4, choleric: 1, melancholic: 1, phlegmatic: 0),
          ),
          QuizOption(
            id: 'no',
            label: 'No',
            emoji: '🤐',
            weights: TemperamentWeights(sanguine: 0, choleric: 1, melancholic: 2, phlegmatic: 3),
          ),
        ],
      ),
      // 18 — Radio buttons (conflicts)
      QuizQuestion(
        index: 18,
        prompt: 'How do you behave during conflicts between others?',
        kind: QuestionInputKind.radioButtons,
        options: [
          QuizOption(
            id: '18a',
            label: 'Try to solve the issue',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 1, phlegmatic: 1),
          ),
          QuizOption(
            id: '18b',
            label: 'Calm everyone down',
            weights: TemperamentWeights(sanguine: 1, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
          QuizOption(
            id: '18c',
            label: 'Stay out of it',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 2, phlegmatic: 3),
          ),
          QuizOption(
            id: '18d',
            label: 'Analyze both sides carefully',
            weights: TemperamentWeights(sanguine: 0, choleric: 1, melancholic: 4, phlegmatic: 1),
          ),
        ],
      ),
      // 19 — Personality cards
      QuizQuestion(
        index: 19,
        prompt: 'Which statement sounds most like you?',
        kind: QuestionInputKind.personalityCards,
        options: [
          QuizOption(
            id: '19a',
            label: '“I love excitement and fun.”',
            emoji: '🎢',
            weights: TemperamentWeights(sanguine: 4, choleric: 1, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '19b',
            label: '“I like achieving goals.”',
            emoji: '🚀',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 0, phlegmatic: 0),
          ),
          QuizOption(
            id: '19c',
            label: '“I value depth and meaning.”',
            emoji: '🔮',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 4, phlegmatic: 1),
          ),
          QuizOption(
            id: '19d',
            label: '“I prefer peace and balance.”',
            emoji: '⚖️',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
        ],
      ),
      // 20 — Select cards recharge
      QuizQuestion(
        index: 20,
        prompt: 'After a stressful day, how do you recharge?',
        kind: QuestionInputKind.selectCards,
        options: [
          QuizOption(
            id: '20a',
            label: 'Spend time with friends',
            emoji: '👋',
            weights: TemperamentWeights(sanguine: 4, choleric: 0, melancholic: 0, phlegmatic: 1),
          ),
          QuizOption(
            id: '20b',
            label: 'Work on goals or hobbies',
            emoji: '🔧',
            weights: TemperamentWeights(sanguine: 1, choleric: 4, melancholic: 1, phlegmatic: 0),
          ),
          QuizOption(
            id: '20c',
            label: 'Reflect alone quietly',
            emoji: '🌙',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 4, phlegmatic: 2),
          ),
          QuizOption(
            id: '20d',
            label: 'Rest peacefully at home',
            emoji: '🛏️',
            weights: TemperamentWeights(sanguine: 0, choleric: 0, melancholic: 1, phlegmatic: 4),
          ),
        ],
      ),
    ];

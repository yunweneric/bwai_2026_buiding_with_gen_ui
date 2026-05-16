import 'quiz_models.dart';

/// Short blurbs for result cards (educational, not clinical).
class TemperamentCopy {
  static String tagline(TemperamentId id) => switch (id) {
    TemperamentId.sanguine => 'Energetic, social, optimistic, expressive.',
    TemperamentId.choleric => 'Driven, direct, goal-focused, decisive.',
    TemperamentId.melancholic => 'Thoughtful, detail-oriented, deep-feeling.',
    TemperamentId.phlegmatic => 'Calm, steady, harmonious, patient.',
  };

  static List<String> strengths(TemperamentId id) => switch (id) {
    TemperamentId.sanguine => [
      'Friendly & approachable',
      'Creative spark',
      'Great communicator',
      'Brings fun to groups',
    ],
    TemperamentId.choleric => [
      'Natural leader',
      'Gets things done',
      'Confident under fire',
      'Clear expectations',
    ],
    TemperamentId.melancholic => [
      'Analytical mind',
      'Loyal & sincere',
      'High standards',
      'Reflective insight',
    ],
    TemperamentId.phlegmatic => [
      'Reliable teammate',
      'Keeps the peace',
      'Consistent energy',
      'Great listener',
    ],
  };

  static List<String> challenges(TemperamentId id) => switch (id) {
    TemperamentId.sanguine => [
      'Can get distracted',
      'May avoid boring details',
      'Impulse vs long plans',
    ],
    TemperamentId.choleric => [
      'Can feel impatient',
      'May overlook feelings',
      'Intensity in conflict',
    ],
    TemperamentId.melancholic => [
      'May overthink',
      'Hard on self',
      'Slow to decide sometimes',
    ],
    TemperamentId.phlegmatic => [
      'Avoids rocking the boat',
      'May resist fast change',
      'Energy for confrontation',
    ],
  };

  static List<String> careers(TemperamentId dominant) => switch (dominant) {
    TemperamentId.sanguine => ['Teaching', 'Sales', 'Events', 'Creative roles'],
    TemperamentId.choleric => ['Management', 'Entrepreneurship', 'Operations', 'Coaching'],
    TemperamentId.melancholic => ['Research', 'Design', 'Writing', 'Quality / QA'],
    TemperamentId.phlegmatic => ['HR', 'Counseling', 'Admin', 'Support roles'],
  };

  static List<String> studyStyles(TemperamentId dominant) => switch (dominant) {
    TemperamentId.sanguine => ['Study groups', 'Pomodoro + rewards', 'Teach-back'],
    TemperamentId.choleric => ['Goal lists', 'Time blocks', 'Compete with self'],
    TemperamentId.melancholic => ['Deep notes', 'Quiet space', 'Review cycles'],
    TemperamentId.phlegmatic => ['Steady routine', 'Low distraction', 'Buddy check-ins'],
  };

  static List<String> relationshipTips(TemperamentId dominant) => switch (dominant) {
    TemperamentId.sanguine => ['Share excitement', 'Plan social time', 'Be direct kindly'],
    TemperamentId.choleric => ['Respect time', 'Be concise', 'Celebrate wins'],
    TemperamentId.melancholic => ['Give processing time', 'Affirm effort', 'Gentle feedback'],
    TemperamentId.phlegmatic => ['Avoid pressure spikes', 'Warm tone', 'Clear plans help'],
  };
}

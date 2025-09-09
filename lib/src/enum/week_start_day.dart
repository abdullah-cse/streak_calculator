/// Defines which day of the week should be considered as the start of a week.
enum WeekStartDay {
  /// Sunday as the first day of the week.
  sunday(DateTime.sunday),

  /// Monday as the first day of the week (ISO 8601 standard).
  monday(DateTime.monday),

  /// Tuesday as the first day of the week.
  tuesday(DateTime.tuesday),

  /// Wednesday as the first day of the week.
  wednesday(DateTime.wednesday),

  /// Thursday as the first day of the week.
  thursday(DateTime.thursday),

  /// Friday as the first day of the week.
  friday(DateTime.friday),

  /// Saturday as the first day of the week.
  saturday(DateTime.saturday);

  const WeekStartDay(this.value);

  /// The corresponding DateTime weekday value.
  final int value;
}

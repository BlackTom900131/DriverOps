/// Status of a workday session.
enum WorkdayStatus {
  notStarted,
  inProgress,
  completed,
}

/// Represents a single workday record (clock in/out, date).
class Workday {
  const Workday({
    required this.id,
    required this.date,
    this.clockIn,
    this.clockOut,
    this.status = WorkdayStatus.notStarted,
  });

  final String id;
  final DateTime date;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final WorkdayStatus status;

  Workday copyWith({
    String? id,
    DateTime? date,
    DateTime? clockIn,
    DateTime? clockOut,
    WorkdayStatus? status,
  }) {
    return Workday(
      id: id ?? this.id,
      date: date ?? this.date,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      status: status ?? this.status,
    );
  }
}

/// Holds the workday feature state (current session + history).
class WorkdayState {
  const WorkdayState({
    this.currentWorkday,
    this.workdays = const [],
    this.isLoading = false,
    this.error,
  });

  final Workday? currentWorkday;
  final List<Workday> workdays;
  final bool isLoading;
  final String? error;

  WorkdayState copyWith({
    Workday? currentWorkday,
    List<Workday>? workdays,
    bool? isLoading,
    String? error,
  }) {
    return WorkdayState(
      currentWorkday: currentWorkday ?? this.currentWorkday,
      workdays: workdays ?? this.workdays,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

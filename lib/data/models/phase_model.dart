import '../../domain/entities/phase.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PhaseTaskModel — nested task template inside a Phase
// ─────────────────────────────────────────────────────────────────────────────

class PhaseTaskModel {
  final String id;
  final String phaseId;
  final String taskType;
  final String title;
  final String description;
  final bool isMandatory;
  final String? questionnaireId;
  final int weekNumberGlobal;
  final int weekNumberInPhase;
  final bool isEvenWeekInPhase;
  final String practitioner;
  final List<String> statusOptions;
  final String defaultStatus;
  final int? points;
  final int orderIndex;
  final String createdAt;
  final String updatedAt;

  const PhaseTaskModel({
    required this.id,
    required this.phaseId,
    required this.taskType,
    required this.title,
    required this.description,
    required this.isMandatory,
    this.questionnaireId,
    required this.weekNumberGlobal,
    required this.weekNumberInPhase,
    required this.isEvenWeekInPhase,
    required this.practitioner,
    required this.statusOptions,
    required this.defaultStatus,
    this.points,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PhaseTaskModel.fromJson(Map<String, dynamic> json) {
    return PhaseTaskModel(
      id: json['id'] as String? ?? '',
      phaseId: json['phaseId'] as String? ?? '',
      taskType: json['taskType'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isMandatory: json['isMandatory'] as bool? ?? false,
      questionnaireId: json['questionnaireId'] as String?,
      weekNumberGlobal: json['weekNumberGlobal'] as int? ?? 0,
      weekNumberInPhase: json['weekNumberInPhase'] as int? ?? 0,
      isEvenWeekInPhase: json['isEvenWeekInPhase'] as bool? ?? false,
      practitioner: json['practitioner'] as String? ?? '',
      statusOptions: (json['statusOptions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      defaultStatus: json['defaultStatus'] as String? ?? '',
      points: json['points'] as int?,
      orderIndex: json['orderIndex'] as int? ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phaseId': phaseId,
        'taskType': taskType,
        'title': title,
        'description': description,
        'isMandatory': isMandatory,
        'questionnaireId': questionnaireId,
        'weekNumberGlobal': weekNumberGlobal,
        'weekNumberInPhase': weekNumberInPhase,
        'isEvenWeekInPhase': isEvenWeekInPhase,
        'practitioner': practitioner,
        'statusOptions': statusOptions,
        'defaultStatus': defaultStatus,
        'points': points,
        'orderIndex': orderIndex,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// PhaseModel — extends Phase entity; returned by GET /phases/{id}
// ─────────────────────────────────────────────────────────────────────────────

class PhaseModel extends Phase {
  @override
  final int? totalAppointments;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  final List<PhaseTaskModel> phaseTasks;

  const PhaseModel({
    required super.id,
    required super.name,
    required super.durationWeeks,
    required super.orderIndex,
    required super.programType,
    this.totalAppointments,
    this.createdAt,
    this.updatedAt,
    this.phaseTasks = const [],
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      durationWeeks: json['durationWeeks'] as int? ?? 0,
      orderIndex: json['orderIndex'] as int? ?? 0,
      programType: json['programType'] as String? ?? '',
      totalAppointments: json['totalAppointments'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      phaseTasks: (json['phaseTasks'] as List<dynamic>?)
              ?.map((e) => PhaseTaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'durationWeeks': durationWeeks,
        'orderIndex': orderIndex,
        'programType': programType,
        'totalAppointments': totalAppointments,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'phaseTasks': phaseTasks.map((t) => t.toJson()).toList(),
      };

  Phase toEntity() => Phase(
        id: id,
        name: name,
        durationWeeks: durationWeeks,
        orderIndex: orderIndex,
        programType: programType,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// PatientTaskModel — a patient's task instance; returned in active-phase/tasks
// ─────────────────────────────────────────────────────────────────────────────

class PatientTaskModel {
  final String id;
  final String patientId;
  final String patientPhaseId;
  final String phaseTaskId;
  final String status;
  final String? completedAt;
  final int weekNumberGlobal;
  final int weekNumberInPhase;
  final String statusValue;
  final String createdAt;
  final String updatedAt;
  final PhaseTaskModel? phaseTask;
  final String taskName;
  final String taskType;
  final String practitioner;
  final List<String> statusOptions;
  final String defaultStatus;
  final String visualIndicator;
  final String legacyStatus;

  const PatientTaskModel({
    required this.id,
    required this.patientId,
    required this.patientPhaseId,
    required this.phaseTaskId,
    required this.status,
    this.completedAt,
    required this.weekNumberGlobal,
    required this.weekNumberInPhase,
    required this.statusValue,
    required this.createdAt,
    required this.updatedAt,
    this.phaseTask,
    this.taskName = '',
    this.taskType = '',
    this.practitioner = '',
    this.statusOptions = const [],
    this.defaultStatus = '',
    this.visualIndicator = '',
    this.legacyStatus = '',
  });

  factory PatientTaskModel.fromJson(Map<String, dynamic> json) {
    return PatientTaskModel(
      id: json['id'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      patientPhaseId: json['patientPhaseId'] as String? ?? '',
      phaseTaskId: json['phaseTaskId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      completedAt: json['completedAt'] as String?,
      weekNumberGlobal: json['weekNumberGlobal'] as int? ?? 0,
      weekNumberInPhase: json['weekNumberInPhase'] as int? ?? 0,
      statusValue: json['statusValue'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      phaseTask: json['phaseTask'] != null
          ? PhaseTaskModel.fromJson(json['phaseTask'] as Map<String, dynamic>)
          : null,
      taskName: json['taskName'] as String? ?? json['title'] as String? ?? '',
      taskType: json['taskType'] as String? ?? '',
      practitioner: json['practitioner'] as String? ?? '',
      statusOptions: (json['statusOptions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      defaultStatus: json['defaultStatus'] as String? ?? '',
      visualIndicator: json['visualIndicator'] as String? ?? '',
      legacyStatus: json['legacyStatus'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'patientPhaseId': patientPhaseId,
        'phaseTaskId': phaseTaskId,
        'status': status,
        'completedAt': completedAt,
        'weekNumberGlobal': weekNumberGlobal,
        'weekNumberInPhase': weekNumberInPhase,
        'statusValue': statusValue,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'phaseTask': phaseTask?.toJson(),
        'taskName': taskName,
        'taskType': taskType,
        'practitioner': practitioner,
        'statusOptions': statusOptions,
        'defaultStatus': defaultStatus,
        'visualIndicator': visualIndicator,
        'legacyStatus': legacyStatus,
      };

  bool get isCompleted => status == 'COMPLETED';
}

// ─────────────────────────────────────────────────────────────────────────────
// PatientPhaseModel — the patient's active phase record
// ─────────────────────────────────────────────────────────────────────────────

class PatientPhaseModel {
  final String id;
  final String patientId;
  final String phaseId;
  final String startDate;
  final String? expectedEndDate;
  final String? actualEndDate;
  final String status;
  final String createdAt;
  final String updatedAt;
  final PhaseModel? phase;

  const PatientPhaseModel({
    required this.id,
    required this.patientId,
    required this.phaseId,
    required this.startDate,
    this.expectedEndDate,
    this.actualEndDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.phase,
  });

  factory PatientPhaseModel.fromJson(Map<String, dynamic> json) {
    return PatientPhaseModel(
      id: json['id'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      phaseId: json['phaseId'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      expectedEndDate: json['expectedEndDate'] as String?,
      actualEndDate: json['actualEndDate'] as String?,
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      phase: json['phase'] != null
          ? PhaseModel.fromJson(json['phase'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'phaseId': phaseId,
        'startDate': startDate,
        'expectedEndDate': expectedEndDate,
        'actualEndDate': actualEndDate,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'phase': phase?.toJson(),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// ActivePhaseResponseModel — data wrapper for GET /phases/my-active-phase
// ─────────────────────────────────────────────────────────────────────────────

class ActivePhaseResponseModel {
  final PatientPhaseModel phase;
  final List<PatientTaskModel> tasks;

  const ActivePhaseResponseModel({
    required this.phase,
    required this.tasks,
  });

  factory ActivePhaseResponseModel.fromJson(Map<String, dynamic> json) {
    return ActivePhaseResponseModel(
      phase: PatientPhaseModel.fromJson(json['phase'] as Map<String, dynamic>),
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => PatientTaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'phase': phase.toJson(),
        'tasks': tasks.map((t) => t.toJson()).toList(),
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// WeeklyProgressModel — progress block inside weekly view or phase progress
// ─────────────────────────────────────────────────────────────────────────────

class WeeklyProgressModel {
  final int completedAppointments;
  final int totalAppointments;
  final bool isPhaseComplete;

  const WeeklyProgressModel({
    required this.completedAppointments,
    required this.totalAppointments,
    required this.isPhaseComplete,
  });

  factory WeeklyProgressModel.fromJson(Map<String, dynamic> json) {
    return WeeklyProgressModel(
      completedAppointments: json['completedAppointments'] as int? ?? 0,
      totalAppointments: json['totalAppointments'] as int? ?? 0,
      isPhaseComplete: json['isPhaseComplete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'completedAppointments': completedAppointments,
        'totalAppointments': totalAppointments,
        'isPhaseComplete': isPhaseComplete,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// WeeklyViewModel — returned by GET /phases/my-active-phase/weekly
//                   and GET /phases/my-active-phase/weeks/{n}
// ─────────────────────────────────────────────────────────────────────────────

class WeeklyViewModel {
  final int currentWeekGlobal;
  final int phaseNumber;
  final String phaseName;
  final int weekInPhase;
  final bool isEvenWeek;
  final List<PatientTaskModel> tasks;
  final WeeklyProgressModel? progress;
  final String? retainUntil;
  // Extra fields present in week-by-number response
  final bool? isCurrentWeek;
  final bool? isReadOnly;

  const WeeklyViewModel({
    required this.currentWeekGlobal,
    required this.phaseNumber,
    required this.phaseName,
    required this.weekInPhase,
    required this.isEvenWeek,
    required this.tasks,
    this.progress,
    this.retainUntil,
    this.isCurrentWeek,
    this.isReadOnly,
  });

  factory WeeklyViewModel.fromJson(Map<String, dynamic> json) {
    return WeeklyViewModel(
      currentWeekGlobal: json['currentWeekGlobal'] as int? ??
          json['weekNumberGlobal'] as int? ??
          0,
      phaseNumber: json['phaseNumber'] as int? ?? 0,
      phaseName: json['phaseName'] as String? ?? '',
      weekInPhase: json['weekInPhase'] as int? ?? 0,
      isEvenWeek: json['isEvenWeek'] as bool? ?? false,
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => PatientTaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      progress: json['progress'] != null
          ? WeeklyProgressModel.fromJson(
              json['progress'] as Map<String, dynamic>)
          : null,
      retainUntil: json['retainUntil'] as String?,
      isCurrentWeek: json['isCurrentWeek'] as bool?,
      isReadOnly: json['isReadOnly'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentWeekGlobal': currentWeekGlobal,
        'phaseNumber': phaseNumber,
        'phaseName': phaseName,
        'weekInPhase': weekInPhase,
        'isEvenWeek': isEvenWeek,
        'tasks': tasks.map((t) => t.toJson()).toList(),
        'progress': progress?.toJson(),
        'retainUntil': retainUntil,
        'isCurrentWeek': isCurrentWeek,
        'isReadOnly': isReadOnly,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// PhaseProgressModel — returned by GET /phases/my-active-phase/progress
// ─────────────────────────────────────────────────────────────────────────────

class PhaseProgressModel {
  final String phaseName;
  final int completedAppointments;
  final int totalAppointments;
  final bool isPhaseComplete;
  final double percentComplete;
  final String? retainUntil;

  const PhaseProgressModel({
    required this.phaseName,
    required this.completedAppointments,
    required this.totalAppointments,
    required this.isPhaseComplete,
    required this.percentComplete,
    this.retainUntil,
  });

  factory PhaseProgressModel.fromJson(Map<String, dynamic> json) {
    final rawPercent = json['percentComplete'];
    final double percent = rawPercent is int
        ? rawPercent.toDouble()
        : rawPercent as double? ?? 0.0;

    return PhaseProgressModel(
      phaseName: json['phaseName'] as String? ?? '',
      completedAppointments: json['completedAppointments'] as int? ?? 0,
      totalAppointments: json['totalAppointments'] as int? ?? 0,
      isPhaseComplete: json['isPhaseComplete'] as bool? ?? false,
      percentComplete: percent,
      retainUntil: json['retainUntil'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'phaseName': phaseName,
        'completedAppointments': completedAppointments,
        'totalAppointments': totalAppointments,
        'isPhaseComplete': isPhaseComplete,
        'percentComplete': percentComplete,
        'retainUntil': retainUntil,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// UpdateTaskStatusRequest — request body for PATCH /tasks/{id}/status
// ─────────────────────────────────────────────────────────────────────────────

class UpdateTaskStatusRequest {
  final String statusValue;

  const UpdateTaskStatusRequest({required this.statusValue});

  Map<String, dynamic> toJson() => {'statusValue': statusValue};
}

// ==========================================
// Time Slot Models
// ==========================================

class TimeSlot {
  final String startTime;
  final String endTime;
  final String displayTime;
  final bool available;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.displayTime,
    required this.available,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      displayTime: json['displayTime'] as String? ?? '',
      available: json['available'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
        'displayTime': displayTime,
        'available': available,
      };
}

class TimeSlotResponse {
  final String date;
  final bool isWorkingDay;
  final int availableSlots;
  final List<TimeSlot> slots;

  const TimeSlotResponse({
    required this.date,
    required this.isWorkingDay,
    required this.availableSlots,
    required this.slots,
  });

  factory TimeSlotResponse.fromJson(Map<String, dynamic> json) {
    // API wraps data in a 'data' key
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return TimeSlotResponse(
      date: data['date'] as String? ?? '',
      isWorkingDay: data['isWorkingDay'] as bool? ?? true,
      availableSlots: data['availableSlots'] as int? ?? 0,
      slots: (data['slots'] as List<dynamic>?)
              ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// ==========================================
// Appointment Member / User Sub-models
// ==========================================

class AppointmentMember {
  final String fullName;
  final String? email;
  final String? phone;
  final String? profileImage;

  const AppointmentMember({
    required this.fullName,
    this.email,
    this.phone,
    this.profileImage,
  });

  factory AppointmentMember.fromJson(Map<String, dynamic> json) {
    return AppointmentMember(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
    );
  }
}

class AppointmentProgram {
  final String id;
  final String name;
  final String type;
  final String price;

  const AppointmentProgram({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
  });

  factory AppointmentProgram.fromJson(Map<String, dynamic> json) {
    return AppointmentProgram(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      price: json['price']?.toString() ?? '0.00',
    );
  }
}

class AppointmentUser {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? mobilePhone;

  const AppointmentUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.mobilePhone,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory AppointmentUser.fromJson(Map<String, dynamic> json) {
    return AppointmentUser(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String?,
      mobilePhone: json['mobilePhone'] as String?,
    );
  }
}

// ==========================================
// Appointment Detail Model
// ==========================================

class AppointmentDetail {
  final String id;
  final String? displayDate;
  final String? displayTime;
  final String? duration;
  final String? notes;
  final String status;
  final AppointmentMember? member;
  final AppointmentUser? user;
  final String? createdAt;
  final String? updatedAt;
  final String? bookingType;
  final String? currentStep;
  final String? period;
  final String? consultationDateTime;
  final AppointmentProgram? program;

  const AppointmentDetail({
    required this.id,
    this.displayDate,
    this.displayTime,
    this.duration,
    this.notes,
    required this.status,
    this.member,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.bookingType,
    this.currentStep,
    this.period,
    this.consultationDateTime,
    this.program,
  });

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
      id: json['id'] as String? ?? '',
      displayDate: json['displayDate'] as String?,
      displayTime: json['displayTime'] as String?,
      duration: json['duration']?.toString(),
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? '',
      member: json['member'] != null
          ? AppointmentMember.fromJson(json['member'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? AppointmentUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      bookingType: json['bookingType'] as String?,
      currentStep: json['currentStep'] as String?,
      period: json['period'] as String?,
      consultationDateTime: json['consultationDateTime'] as String?,
      program: json['program'] != null
          ? AppointmentProgram.fromJson(json['program'] as Map<String, dynamic>)
          : null,
    );
  }
}

// ==========================================
// API Response wrappers
// ==========================================

/// Returned by bookAppointment and getAppointmentById
class AppointmentResponseData {
  final AppointmentDetail? appointment;

  // Legacy fields kept for cancel/update flows that still use /bookings
  final String? bookingId;
  final String? status;

  const AppointmentResponseData({
    this.appointment,
    this.bookingId,
    this.status,
  });

  factory AppointmentResponseData.fromJson(Map<String, dynamic> json) {
    // New endpoints nest under 'appointment'
    final apptJson = json['appointment'] as Map<String, dynamic>?;
    print('apptJson :$apptJson');
    return AppointmentResponseData(
      appointment:
          apptJson != null ? AppointmentDetail.fromJson(apptJson) : null,
      bookingId: json['bookingId'] as String?,
      status: json['status'] as String?,
    );
  }
}

/// Returned by getUserAppointments (GET /bookings/appointments/all)
class UserAppointmentsResponse {
  final List<AppointmentDetail> appointments;

  const UserAppointmentsResponse({required this.appointments});

  factory UserAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    final appointmentsJson = json['appointments'] as List<dynamic>? ?? [];
    return UserAppointmentsResponse(
      appointments: appointmentsJson
          .map((e) => AppointmentDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ==========================================
// Request Models
// ==========================================

/// Used by bookAppointment (POST /specialist-timeslots/care-team/{id}/book)
class BookAppointmentRequest {
  final String startTime;
  final String? notes;

  const BookAppointmentRequest({
    required this.startTime,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'startTime': startTime};
    if (notes != null) map['notes'] = notes;
    return map;
  }
}

/// Legacy — kept so existing cancelAppointment / updateAppointment still compile
class UpdateAppointmentRequest {
  final String location;

  const UpdateAppointmentRequest({required this.location});

  Map<String, dynamic> toJson() => {'location': location};
}

class CancelAppointmentResponseData {
  final String? bookingId;

  const CancelAppointmentResponseData({this.bookingId});

  factory CancelAppointmentResponseData.fromJson(Map<String, dynamic> json) {
    return CancelAppointmentResponseData(
      bookingId: json['bookingId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'bookingId': bookingId};
}

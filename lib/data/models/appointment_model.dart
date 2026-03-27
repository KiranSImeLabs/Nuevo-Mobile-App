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

class AppointmentUser {
  final String firstName;
  final String lastName;

  const AppointmentUser({
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory AppointmentUser.fromJson(Map<String, dynamic> json) {
    return AppointmentUser(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
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
  final int? duration;
  final String? notes;
  final String status;
  final AppointmentMember? member;
  final AppointmentUser? user;
  final String? createdAt;

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
  });

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
      id: json['id'] as String? ?? '',
      displayDate: json['displayDate'] as String?,
      displayTime: json['displayTime'] as String?,
      duration: json['duration'] as int?,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? '',
      member: json['member'] != null
          ? AppointmentMember.fromJson(json['member'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? AppointmentUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
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
    return AppointmentResponseData(
      appointment: apptJson != null ? AppointmentDetail.fromJson(apptJson) : null,
      bookingId: json['bookingId'] as String?,
      status: json['status'] as String?,
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

import 'package:tech/core/models/service.dart';

enum AppointmentStatus {
  planned,
  started,
  paused,
  completed,
  stopped,
  cancelled,
  unknown,
}

extension AppointmentStatusExtension on AppointmentStatus {
  String toApiString() {
    return toString().split('.').last;
  }

  static AppointmentStatus parse(String statusString) {
    switch (statusString) {
      case 'started':
        return AppointmentStatus.started;
      case 'paused':
        return AppointmentStatus.paused;
      case 'completed':
        return AppointmentStatus.completed;
      case 'stopped':
        return AppointmentStatus.stopped;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'planned':
        return AppointmentStatus.planned;
      default:
        return AppointmentStatus.unknown;
    }
  }
}


class AppointmentDisplayData {
  final int id;
  final AppointmentStatus status;
  final int remainingMinutes;
  final String action;
  final DateTime timestamp;
  final int durationMinutes;
  final ServiceRequestDisplayData? serviceRequest;

  AppointmentDisplayData({
    required this.id,
    required this.status,
    required this.remainingMinutes,
    required this.action,
    required this.timestamp,
    required this.durationMinutes,
    this.serviceRequest,
  });

  factory AppointmentDisplayData.fromJson(Map<String, dynamic> json) {
    print('JSON received by AppointmentDisplayData.fromJson: $json'); // Pour le debug

    final serviceRequestData = json['service_request'];

    return AppointmentDisplayData(
      id: json['id'] as int,
      status: AppointmentStatusExtension.parse(json['status'] as String),
      remainingMinutes: json['remaining_minutes'] as int? ?? 0,
      action: json['action'] as String? ?? 'initial_load',
      timestamp: DateTime.tryParse(json['updated_at']?.toString() ?? json['created_at']?.toString() ?? '') ?? DateTime.now(),
      durationMinutes: serviceRequestData != null ? serviceRequestData['duration_minutes'] as int? ?? 0 : 0,
      /*serviceRequest: ServiceRequestDisplayData.fromJson(serviceRequestData),*/
    );
  }
}

// models/booking_model.dart
class BookingModel {
  final String id, customerName, serviceId, startTime, endTime, reference, status;

  BookingModel({
    required this.id,
    required this.customerName,
    required this.serviceId,
    required this.startTime,
    required this.endTime,
    required this.reference,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json['id'],
    customerName: json['customer_name'],
    serviceId: json['service_id'],
    startTime: json['start_time'],
    endTime: json['end_time'],
    reference: json['reference'],
    status: json['status'],
  );
}

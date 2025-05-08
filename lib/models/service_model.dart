// models/service_model.dart
class ServiceModel {
  final String id, name, category;
  final String duration, price;

  ServiceModel({required this.id, required this.name, required this.duration, required this.price, required this.category});

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json['id'],
    name: json['name'],
    duration: json['duration'],
    price: json['price'],
    category: json['category'],
  );
}

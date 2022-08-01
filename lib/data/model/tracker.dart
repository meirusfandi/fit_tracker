import 'package:equatable/equatable.dart';

class Tracker extends Equatable {
  const Tracker({
    required this.id,
    required this.weight,
    required this.date,
    required this.height
  });

  final String id;
  final String weight;
  final String date;
  final String height;

  factory Tracker.fromJson(Map<String, dynamic> json) => Tracker(
      id: json['id'] ?? "",
      date: json['date'] ?? "",
      weight: json['weight'] ?? "",
      height: json['height'] ?? ""
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'date': date,
    'weight': weight,
    'height': height
  };

  factory Tracker.empty() => const Tracker(
      id: "",
      date: "",
      height: "",
      weight: "",
  );

  @override
  List<Object?> get props => [id, weight, date, height];

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Tracker extends Equatable {
  const Tracker({
    required this.id,
    required this.data,
  });

  final String id;
  final TrackerData data;

  factory Tracker.fromJson(Map<String, dynamic> json) => Tracker(
      id: json['id'] ?? "",
      data: json['data']
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'data': data
  };

  @override
  List<Object?> get props => [id, data];

}

class TrackerData extends Equatable{
  const TrackerData({
    required this.id,
    required this.weight,
    required this.date,
    required this.height
  });

  final String id;
  final String weight;
  final Timestamp date;
  final String height;

  factory TrackerData.fromJson(Map<String, dynamic> json) => TrackerData(
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

  @override
  List<Object?> get props => [id, weight, date, height];
}
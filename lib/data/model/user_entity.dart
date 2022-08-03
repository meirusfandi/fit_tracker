import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.height
  });

  final String id;
  final String name;
  final String email;
  final String gender;
  final String dateOfBirth;
  final String height;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: json['id'] ?? "",
    name: json['name'] ?? "",
    email: json['email'] ?? "",
    gender: json['gender'] ?? "",
    dateOfBirth: json['dateOfBirth'] ?? "",
    height: json['height'] ?? 0
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'email': email,
    'gender': gender,
    'dateOfBirth': dateOfBirth,
    'height': height
  };

  factory UserEntity.empty() => const UserEntity(
    id: "",
    name: "",
    email: "",
    gender: "",
    dateOfBirth: "",
    height: ""
  );

  @override
  List<Object?> get props => [id, name, email, gender, dateOfBirth, height];

}
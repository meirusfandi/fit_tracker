import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
    required this.gender,
    required this.dateOfBirth,
    required this.height
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final String gender;
  final String dateOfBirth;
  final String height;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: json['id'] ?? "",
    firstName: json['firstName'] ?? "",
    lastName: json['lastName'] ?? "",
    email: json['email'] ?? "",
    imageUrl: json['imageUrl'] ?? "",
    gender: json['gender'] ?? "",
    dateOfBirth: json['dateOfBirth'] ?? "",
    height: json['height'] ?? ""
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'imageUrl': imageUrl,
    'gender': gender,
    'dateOfBirth': dateOfBirth,
    'height': height
  };

  factory UserEntity.empty() => const UserEntity(
    id: "",
    firstName: "",
    lastName: "",
    email: "",
    imageUrl: "",
    gender: "",
    dateOfBirth: "",
    height: ""
  );

  @override
  List<Object?> get props => [id, firstName, lastName, email, imageUrl, gender, dateOfBirth, height];

}
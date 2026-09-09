import 'package:cloud_firestore/cloud_firestore.dart';

class SetupModel {
  final DateTime? dateOfBirth;
  final String? gender;
  final double? height;
  final double? weight;

  const SetupModel({this.dateOfBirth, this.gender, this.height, this.weight});

  factory SetupModel.fromJson(Map<String, dynamic> json) {
    return SetupModel(
      dateOfBirth: (json['dateOfBirth'] as Timestamp?)?.toDate(),
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateOfBirth': dateOfBirth != null
          ? Timestamp.fromDate(dateOfBirth!)
          : null,
      'gender': gender,
      'height': height,
      'weight': weight,
    };
  }
}

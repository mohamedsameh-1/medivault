import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.uId,
    super.fullName,
    super.email,
    super.dateOfBirth,
    super.gender,
    super.height,
    super.weight,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uId: json['uId'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['dateOfBirth'] is Timestamp
          ? (json['dateOfBirth'] as Timestamp).toDate()
          : json['dateOfBirth'] is DateTime
              ? json['dateOfBirth'] as DateTime
              : json['dateOfBirth'] is String
                  ? DateTime.tryParse(json['dateOfBirth'] as String)
                  : null,
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'fullName': fullName,
      'email': email,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
      'height': height,
      'weight': weight,
    };
  }
}

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.uId,
    super.email,
    super.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'email': email,
      'fullName': fullName,
    };
  }
}

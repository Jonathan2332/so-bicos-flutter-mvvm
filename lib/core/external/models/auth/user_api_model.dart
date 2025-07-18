// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserApiModel {
  String? name;
  String? email;
  String? phoneNumber;
  UserApiModel({this.name, this.email, this.phoneNumber});

  UserApiModel copyWith({String? name, String? email, String? phoneNumber}) {
    return UserApiModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

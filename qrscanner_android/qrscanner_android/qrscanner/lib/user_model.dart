import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel(
      {required this.username,
      required this.password,
      required this.role,
      required this.companyTheme});

  String username;
  String password;
  String role;
  String companyTheme;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      username: json["username"],
      password: json["password"],
      role: json["role"],
      companyTheme: json["companyTheme"]);

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "role": role,
        "companyTheme": companyTheme
      };
}

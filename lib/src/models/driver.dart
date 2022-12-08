import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  Driver({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.plate,
  });

  String id;
  String username;
  String email;
  String password;
  String plate;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        plate: json["plate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "plate": plate,
      };
}

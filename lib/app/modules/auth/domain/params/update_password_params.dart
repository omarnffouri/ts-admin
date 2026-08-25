class UpdatePasswordParams {
  final String? password;
  final String? newPassword;

  UpdatePasswordParams({
    this.password,
    this.newPassword,
  });

  factory UpdatePasswordParams.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordParams(
        password: json["password"],
        newPassword: json["new_password"],
      );

  Map<String, dynamic> toJson() => {
        "password": password,
        "new_password": newPassword,
      };
}

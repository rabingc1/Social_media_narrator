class LoginModel {
  String email;
  String password;

  LoginModel({required this.email, required this.password});

  LoginModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class SignUpModel {
  final String id;
  final String name;
  final String email;
  final String location;
  final String password;
  final String repassword;
  final String phoneNumber; // Added phone number field
  final bool admin;
  final List<String> categories; // Added categories field

  SignUpModel({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.password,
    required this.repassword,
    required this.phoneNumber, // Updated constructor
    required this.admin,
    required this.categories, // Updated constructor
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      location: json['location'] as String,
      password: json['password'] as String,
      repassword: json['repassword'] as String,
      phoneNumber: json['phoneNumber'] as String, // Updated fromJson
      admin: json['admin'] as bool,
      categories:
          List<String>.from(json['categories'] as List), // Updated fromJson
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'location': location,
      'password': password,
      'repassword': repassword,
      'phoneNumber': phoneNumber, // Updated toJson
      'admin': admin,
      'categories': categories, // Updated toJson
    };
  }
}

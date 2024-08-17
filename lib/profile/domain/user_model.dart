class UserModel {
  final String id;
  final String name;
  final String email;
  final String location;
  final String? profileImageUrl;
  final bool? admin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    this.profileImageUrl,
    required this.admin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      location: json['location'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      admin: json['admin'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'location': location,
      'profileImageUrl': profileImageUrl,
      'admin': admin,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? location,
    String? profileImageUrl,
    bool? admin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      admin: admin ?? this.admin,
    );
  }
}

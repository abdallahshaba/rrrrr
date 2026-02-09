class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      photoUrl: map['photo_url'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
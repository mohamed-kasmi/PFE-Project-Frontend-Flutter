class User {
  final int id;
  final int matricule;
  final String email;
  final String role;
  User({
    required this.id,
    required this.matricule,
    required this.email,
    required this.role,
  });
  @override
  String toString() {
    return 'User{id: $id, matricule: $matricule, email: $email, role: $role}';
  }
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'matricule': matricule,
      'email': email,
      'role': role,
    };
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id'].toString()) ?? json['id'],
      matricule: json['matricule'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }
}

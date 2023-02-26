class UserData {
  final String email;
  final String password;
  final String name;
  final String gender;
  final String dob;
  final dynamic height;
  final dynamic weight;

  UserData({
    required this.email,
    required this.password,
    required this.name,
    required this.gender,
    required this.dob,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'gender': gender,
      'dob': dob,
      'height': height,
      'weight': weight,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      gender: json['gender'],
      dob: json['dob'],
      height: json['height'],
      weight: json['weight'],
    );
  }
}

class MyUser {
  final String? id;
  final String username;
  final String password;
  final String birthDay;
  final String gender;
  final String phoneNum;
  final String email;
  final String role;
  final String state;

  const MyUser({
    this.id,
    required this.username,
    required this.password,
    required this.birthDay,
    required this.gender,
    required this.phoneNum,
    required this.state,
    required this.email,
    required this.role
  });
  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "Username": username,
      "Password": password,
      "BirthDay": birthDay,
      "Gender": gender,
      "PhoneNum": phoneNum,
      "State": state,
      "Email": email,
      "Role": role
    };
  }
}

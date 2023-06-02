class UserModel {
  String userId;
  String? name;
  String email;
  String? role;
  String? phone;
  String? picture;
  String? deliveryAddress;
  int? userCreationTime;

  UserModel(
      {required this.userId,
      this.name,
      required this.email,
      this.role = "User",
      this.phone,
      this.picture,
      this.deliveryAddress,
      this.userCreationTime});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'picture': picture,
      'deliveryAddress': deliveryAddress,
      'userCreationTime': userCreationTime,
    };
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map['userId'],
        name: map['name'],
        email: map['email'],
        role: map['role'],
        phone: map['phone'],
        picture: map['picture'],
        userCreationTime: map['userCreationTime'],
        deliveryAddress: map['deliveryAddress'],
      );
}

class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? photo;

  UserModel({
    this.uid,
    this.fullname,
    this.email,
    this.photo,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      fullname: map['fullname'],
      email: map['email'],
      photo: map['photo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'photo': photo,
    };
  }
}

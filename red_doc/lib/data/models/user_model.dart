// Represents the logged in user.

class UserModel {
  String uid;
  String name;
  String email;

  UserModel({required this.uid, required this.name, required this.email});

  // Turns a Firestore document (Map) into a UserModel object.
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(uid: map['uid'], name: map['name'], email: map['email']);
  }

  // Turns this UserModel back into a Map, to save it in Firestore.
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}

class UserModel {
  String? uid;
  String? address;
  String? name;
  String? email;
  String? phone;
  String? role;
  String? status;
  String? s;
  int? average;

  UserModel(
      {this.uid,
      this.address,
      this.name,
      this.email,
      this.phone,
      this.role,
      this.status,
      this.s,
      this.average});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    address = map["address"];
    name = map["name"];
    email = map["email"];
    phone = map["phone"];
    role = map["role"];
    status = map["status"];
    s = map["s"];
    average = map["average"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "address": address,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "status": status,
      "s": s,
      "average": average,
    };
  }
}

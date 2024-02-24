import 'package:cloud_firestore/cloud_firestore.dart';

class users {
  String id = '';
  String email = '';
  String password = '';
  String userName = '';
  String role = 'client';
  bool IsApproved = true;
  String fotoUrl = '';

  bool IsAdmin() {
    if (role == 'admin') {
      return true;
    } else {
      return false;
    }
  }

  users(this.id, this.email, this.password, this.userName, this.role,
      this.IsApproved, this.fotoUrl);

  users.empty() {
    id = '';
    email = '';
    password = '';
    userName = '';
    role = 'client';
    IsApproved = true;
    fotoUrl = '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'userName': userName,
      'role': role,
      'IsApproved': IsApproved,
      'fotoUrl': fotoUrl,
    };
  }

  users.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    this.id = snapshot.id;

    this.email = snapshot["email"];
    this.password = snapshot["password"];
    this.userName = snapshot["userName"];
    this.role = snapshot["role"];
    this.IsApproved = snapshot["IsApproved"];
    this.fotoUrl = snapshot["fotoUrl"];
  }

  users.fromQuerySnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    this.id = snapshot.docs[0].id;

    List<Map<String, dynamic>> allData =
        snapshot.docs.map((doc) => doc.data()).toList();

    this.email = allData[0]["email"];
    this.password = allData[0]["password"];
    this.userName = allData[0]["userName"];
    this.role = allData[0]["role"];
    this.IsApproved = allData[0]["IsApproved"];
    this.fotoUrl = allData[0]["fotoUrl"];
  }

  @override
  String toString() {
    return 'id = $id, email = $email, password = $password, userName = $userName, role = $role, IsApproved = $IsApproved, fotoUrl = $fotoUrl';
  }
}

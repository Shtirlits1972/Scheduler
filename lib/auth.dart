import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scheduler_app/model/auth_result.dart';
import 'package:scheduler_app/model/users.dart';

class Auth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> SavePasswordAndDysplayName(
      String newPassword, String newDysplayName) async {
    var user = FirebaseAuth.instance.currentUser!;

    try {
      await user!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }

    try {
      await user!.updateDisplayName(newDysplayName);
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future<User?> registerEmailAndPassword(
      String email, String password, String displayName) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    result.user!.updateDisplayName(displayName);

    FirebaseFirestore.instance
        .collection('userProfile')
        .add({'userId': result.user!.uid, 'role': 'client'});

    return result.user!;
  }

  static Future<AuthResult> singInEmailAndPassword(
      String email, String password) async {
    AuthResult result = AuthResult.empty();
    users user = users.empty();

    try {
      UserCredential userCredit = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      int h22 = 0;
      if (userCredit.user == null) {
        result.isError = true;
        result.txtError = 'invalid autorization';
        result.user = user;
        return result;
      } else {
        print('singInEmailAndPassword');
        print(userCredit);

        String uid = userCredit.user!.uid;
        String userName = userCredit.user!.displayName!;

        user.id = uid;
        user.userName = userName;
        user.password = password;

        CollectionReference collectionRef =
            FirebaseFirestore.instance.collection('userProfile');

        // Создание запроса с условием фильтрации по свойству
        Query query = collectionRef
            .where('userId', isEqualTo: userCredit.user!.uid)
            .limit(1);

        // Выполнение запроса
        QuerySnapshot querySnapshot = await query.get();

        if (querySnapshot.size > 0) {
          // Документ найден
          DocumentSnapshot ds = querySnapshot.docs[0];

          user.role = ds['role'];

          result.isError = false;
          result.txtError = '';
          result.user = user;

          return result;
        } else {
          print('профиль пользователя не найден');
          result.isError = true;
          result.txtError = 'профиль пользователя не найден';
          result.user = user;
          return result;
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      result.isError = true;
      result.txtError = e.message!;
      result.user = user;
      return result;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}

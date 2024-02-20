import 'package:scheduler_app/model/users.dart';

class AuthResult {
  users user = users.empty();
  bool isError = false;
  String txtError = '';

  AuthResult(this.user, this.isError, this.txtError);

  AuthResult.empty() {
    this.user = users.empty();
    this.isError = false;
    this.txtError = '';
  }
}

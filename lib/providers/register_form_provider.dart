import 'package:flutter/material.dart';
import '../models/user.dart';

class RegisterFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  User? usuario;
  String? password;

  bool _estaCargando = false;
  bool get estaCargando => _estaCargando;

  RegisterFormProvider() {
    resetForm();
  }

  set estaCargando(bool value) {
    _estaCargando = value;
    notifyListeners();
  }

  void resetForm() {
    usuario = User(
      name: '',
      last_name: '',
      phone: '',
      email: '',
      password: '',
    );
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}

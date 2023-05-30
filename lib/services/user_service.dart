import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserService extends ChangeNotifier {
  final String _baseUrl = 'ucentral-img-classifier-default-rtdb.firebaseio.com';
  String id_usuario = '';
  bool cargandoUsuario = true;
  bool isSaving = false;

  late User usuario_logueado = User(
    name: '',
    last_name: '',
    phone: '',
    email: '',
    password: '',
  );

  Future<User> loadUsuario() async {
    cargandoUsuario = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'Users.json',
        {'orderBy': '"email"', 'equalTo': '"${usuario_logueado.email}"'});
    final respuesta = await http.get(url);
    final Map<String, dynamic> usuarioMap = json.decode(respuesta.body);
    final usuario = User.fromMap(usuarioMap.values.first);
    usuario.id = usuarioMap.keys.first;
    usuario_logueado = usuario;
    cargandoUsuario = false;
    notifyListeners();
    return usuario_logueado;
  }

  Future salvarOCrearUsuario(User usuario) async {
    isSaving = true;
    notifyListeners();
    if (usuario.id != null) {
      id_usuario = await actualizarUsuario(usuario);
    } else {
      id_usuario = await crearUsuario(usuario);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> crearUsuario(User usuario) async {
    final url = Uri.https(_baseUrl, 'Users.json');
    final respuesta = await http.post(url, body: usuario.toJson());
    final decodeData = json.decode(respuesta.body);
    usuario.id = decodeData['name'];
    return usuario.id!;
  }

  Future<String> actualizarUsuario(User usuario) async {
    final url = Uri.https(_baseUrl, 'Users/${usuario.id}.json');
    await http.put(url, body: usuario.toJson());
    return usuario.id!;
  }
}

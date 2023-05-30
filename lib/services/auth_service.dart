import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:img_classifier/providers/disposable_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService extends DisposableProvider {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _dbBaseUrl =
      'ucentral-img-classifier-default-rtdb.firebaseio.com';
  final String _firebaseToken = 'AIzaSyBz1GycwODiWlquZBFttTCl6-vwNxHwRtE';
  final storage = FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, String> authData = {'email': email, 'password': password};

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    if (decodeResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodeResp['idToken']);
      return null;
    } else {
      return decodeResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, String> authData = {'email': email, 'password': password};

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    if (decodeResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodeResp['idToken']);
      return null;
    } else {
      return decodeResp['error']['message'];
    }
  }

  Future<String?> updateUser(
      String idToken, String email, String password) async {
    final Map<String, String> authData = {
      'idToken': idToken,
      'email': email,
      'password': password
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:update', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    if (decodeResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodeResp['idToken']);
      return null;
    } else {
      return decodeResp['error']['message'];
    }
  }

  Future<String?> obtenerSalUsuario(String email) async {
    final url = Uri.https(_dbBaseUrl, 'Users.json',
        {'orderBy': '"email"', 'equalTo': '"$email"'});
    final respuesta = await http.get(url);
    final Map<String, dynamic> usuarioMap = json.decode(respuesta.body);
    print(usuarioMap);
    if (usuarioMap.isEmpty) {
      return null;
    } else {
      final usuario = User.fromMap(usuarioMap.values.first);
      return usuario.password.substring(0, 24);
    }
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future logout() async {
    DefaultCacheManager().emptyCache();
    await storage.delete(key: 'token');
  }

  String generarHashPassword(String password, {String? sal}) {
    sal ??= generarSal();
    final bytes = utf8.encode(password + sal);
    final hash = sha256.convert(bytes);
    final hashString = hash.toString();
    return sal + hashString;
  }

  String generarSal() {
    final random = Random.secure();
    final valores = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(valores);
  }

  bool esValidaLaContrasena(String contrasena, String hashContrasenaBD) {
    final sal = hashContrasenaBD.substring(0, 24);
    final hashOriginal = hashContrasenaBD.substring(22);
    final nuevoHash = generarHashPassword(contrasena, sal: sal).substring(22);
    return nuevoHash == hashOriginal;
  }

  @override
  void disposeValues() {
    // TODO: implement disposeValues
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.service.dart';

class AuthService {
  static Future<Map<String, dynamic>> loginCliente(String email, String password) async {
    final response = await ApiService.post('/cliente/login', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(data));
      return data;
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  static Future<void> registerCliente(String email, String nombreCompleto, String password, String telefono) async {
    final response = await ApiService.post('/cliente/registro', {
      'email': email,
      'nombrecompleto': nombreCompleto,
      'password': password,
      'telefono': telefono,
    });

    if (response.statusCode != 200) {
      throw Exception('Error al registrarse');
    }
  }

  static Future<void> logoutCliente() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }

  static Future<Map<String, dynamic>?> getClienteInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');
    return userData != null ? jsonDecode(userData) : null;
  }
}

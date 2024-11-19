import 'dart:convert';
import 'api.service.dart';

class LugarService {
  static Future<dynamic> advancedSearchLugares({
    required String ciudad,
    required String cantCamas,
    required String cantBanios,
    required String cantHabitaciones,
    required String tieneWifi,
    required String cantVehiculosParqueo,
    required String precioNoche,
  }) async {
    final response = await ApiService.post('/lugares/advancedsearch', {
      'ciudad': ciudad,
      'cantCamas': cantCamas,
      'cantBanios': cantBanios,
      'cantHabitaciones': cantHabitaciones,
      'tieneWifi': tieneWifi,
      'cantVehiculosParqueo': cantVehiculosParqueo,
      'precioNoche': precioNoche,
    });

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      // Si la respuesta es un arreglo, retórnalo como tal
      if (decodedResponse is List) {
        return decodedResponse;
      }
      // Si es un objeto (mapa), retórnalo como tal
      if (decodedResponse is Map<String, dynamic>) {
        return decodedResponse;
      }
      throw Exception('Respuesta inesperada del servidor');
    } else {
      throw Exception('Por favor ingrese algo en ciudad');
    }
  }

  static Future<Map<String, dynamic>> getLugarById(int id) async {
    final response = await ApiService.get('/lugares/$id');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener el lugar por ID');
    }
  }
}

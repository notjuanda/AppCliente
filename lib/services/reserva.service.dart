import 'dart:convert';
import 'api.service.dart';

class ReservaService {
  static Future<List<dynamic>> getReservasByCliente(int clienteId) async {
    final response = await ApiService.get('/reservas/cliente/$clienteId');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener reservas del cliente');
    }
  }

  static Future<Map<String, dynamic>> createReserva({
    required int lugarId,
    required int clienteId,
    required String fechaInicio,
    required String fechaFin,
    required String precioTotal,
    required String precioLimpieza,
    required String precioNoches,
    required String precioServicio,
  }) async {
    final response = await ApiService.post('/reservas', {
      'lugar_id': lugarId,
      'cliente_id': clienteId,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
      'precioTotal': precioTotal,
      'precioLimpieza': precioLimpieza,
      'precioNoches': precioNoches,
      'precioServicio': precioServicio,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear la reserva');
    }
  }
}

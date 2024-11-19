import 'package:flutter/material.dart';
import 'package:airbnbcliente/services/auth.service.dart';
import 'package:airbnbcliente/services/reserva.service.dart';
// ignore: unused_import
import 'package:intl/intl.dart';

class ReservasPage extends StatefulWidget {
  @override
  _ReservasPageState createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  bool isLoading = true;
  List<dynamic> reservas = [];

  @override
  void initState() {
    super.initState();
    fetchReservas();
  }

  Future<void> fetchReservas() async {
    try {
      final clienteInfo = await AuthService.getClienteInfo();
      if (clienteInfo == null) throw Exception('Usuario no autenticado.');

      final clienteId = clienteInfo['id'];
      final data = await ReservaService.getReservasByCliente(clienteId);

      setState(() {
        reservas = data;
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar reservas: $error')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Mis Reservas'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : reservas.isEmpty
              ? Center(
                  child: Text(
                    'No tienes reservas.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: reservas.length,
                  itemBuilder: (context, index) {
                    final reserva = reservas[index];
                    final lugar = reserva['lugar'][0];
                    final foto = lugar['fotos'].isNotEmpty
                        ? lugar['fotos'][0]['url']
                        : 'https://via.placeholder.com/150';

                    return Card(
                      margin: EdgeInsets.all(16.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Foto del lugar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                foto,
                                height: 200.0,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 16.0),

                            // Nombre del lugar
                            Text(
                              lugar['nombre'],
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),

                            // Fechas de reserva
                            _buildDetailRow(
                              Icons.calendar_today,
                              'Fechas',
                              '${reserva['fechaInicio']} - ${reserva['fechaFin']}',
                            ),

                            // Precios
                            _buildDetailRow(
                              Icons.attach_money,
                              'Precio total',
                              '\$${reserva['precioTotal']}',
                            ),
                            _buildDetailRow(
                              Icons.cleaning_services,
                              'Costo limpieza',
                              '\$${reserva['precioLimpieza']}',
                            ),
                            _buildDetailRow(
                              Icons.nights_stay,
                              'Precio noches',
                              '\$${reserva['precioNoches']}',
                            ),
                            _buildDetailRow(
                              Icons.miscellaneous_services,
                              'Costo servicio',
                              '\$${reserva['precioServicio']}',
                            ),

                            Divider(),

                            // Ciudad
                            _buildDetailRow(
                              Icons.location_city,
                              'Ciudad',
                              lugar['ciudad'],
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 8.0),
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

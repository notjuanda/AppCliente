import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:airbnbcliente/pages/reservar.page.dart';

class LugarDetailPage extends StatelessWidget {
  final Map<String, dynamic> lugar;

  LugarDetailPage({required this.lugar});

  @override
  Widget build(BuildContext context) {
    final fotos = lugar['fotos'] ?? [];
    final double latitud = double.tryParse(lugar['latitud']) ?? 0.0;
    final double longitud = double.tryParse(lugar['longitud']) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          lugar['nombre'] ?? 'Detalle del Lugar',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galería de fotos
            if (fotos.isNotEmpty)
              SizedBox(
                height: 250.0,
                child: PageView.builder(
                  itemCount: fotos.length,
                  itemBuilder: (context, index) {
                    final fotoUrl = fotos[index]['url'] ?? 'https://via.placeholder.com/300';
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(fotoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Nombre del lugar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lugar['nombre'] ?? 'Sin nombre',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    lugar['descripcion'] ?? 'Sin descripción disponible.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            Divider(thickness: 2),

            // Detalles del lugar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalles',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildDetailRow(Icons.group, 'Capacidad', '${lugar['cantPersonas']} personas'),
                  _buildDetailRow(Icons.bed, 'Camas', '${lugar['cantCamas']} camas'),
                  _buildDetailRow(Icons.bathroom, 'Baños', '${lugar['cantBanios']} baños'),
                  _buildDetailRow(Icons.door_front_door_outlined, 'Habitaciones',
                      '${lugar['cantHabitaciones']} habitaciones'),
                  _buildDetailRow(Icons.wifi, 'WiFi', lugar['tieneWifi'] == 1 ? 'Sí' : 'No'),
                  _buildDetailRow(Icons.local_parking, 'Parqueo',
                      '${lugar['cantVehiculosParqueo']} vehículos'),
                  _buildDetailRow(Icons.attach_money, 'Precio por noche', '\$${lugar['precioNoche']}'),
                  _buildDetailRow(Icons.cleaning_services, 'Costo de limpieza', '\$${lugar['costoLimpieza']}'),
                ],
              ),
            ),

            Divider(thickness: 2),

            // Información del arrendatario
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información del arrendatario',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  _buildDetailRow(Icons.person, 'Nombre', lugar['arrendatario']['nombrecompleto']),
                  _buildDetailRow(Icons.email, 'Email', lugar['arrendatario']['email']),
                  _buildDetailRow(Icons.phone, 'Teléfono', lugar['arrendatario']['telefono']),
                ],
              ),
            ),

            Divider(thickness: 2),

            // Mapa
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ubicación',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 250,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitud, longitud),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('lugar_marker'),
                          position: LatLng(latitud, longitud),
                          infoWindow: InfoWindow(title: lugar['nombre']),
                        ),
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Botón de reservar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservaPage(lugar: lugar),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    'Reservar Ahora',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 12.0),
          Text(
            '$title:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

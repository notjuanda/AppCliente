import 'package:flutter/material.dart';
import 'package:airbnbcliente/pages/lugarDetail.page.dart'; // Importa la página de detalle

class LugarList extends StatelessWidget {
  final List<dynamic> lugares;

  LugarList({required this.lugares});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lugares.length,
      itemBuilder: (context, index) {
        final lugar = lugares[index];
        final fotos = lugar['fotos'] ?? [];
        final primeraFoto = fotos.isNotEmpty
            ? fotos[0]['url'] // Primera foto disponible
            : 'https://via.placeholder.com/150'; // Imagen predeterminada

        return GestureDetector(
          onTap: () {
            // Navega a la página de detalle al tocar un lugar
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LugarDetailPage(lugar: lugar),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del lugar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      primeraFoto,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Nombre del lugar
                  Text(
                    lugar['nombre'] ?? 'Sin nombre',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),

                  // Descripción del lugar
                  Text(
                    lugar['descripcion'] ?? 'Sin descripción',
                    style: TextStyle(fontSize: 14.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),

                  // Información adicional (Ciudad y Precio)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lugar['ciudad'] ?? 'Ciudad no especificada',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                      Text(
                        '\$${lugar['precioNoche'] ?? '0.00'}/noche',
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

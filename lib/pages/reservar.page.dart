import 'package:flutter/material.dart';
import 'package:airbnbcliente/services/auth.service.dart';
import 'package:airbnbcliente/services/reserva.service.dart';
import 'package:intl/intl.dart';

class ReservaPage extends StatefulWidget {
  final Map<String, dynamic> lugar;

  ReservaPage({required this.lugar});

  @override
  _ReservaPageState createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  bool _isLoading = false;

  Future<void> _selectFechaInicio() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (picked != null && picked != _fechaInicio) {
      setState(() {
        _fechaInicio = picked;
      });
    }
  }

  Future<void> _selectFechaFin() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio ?? DateTime.now(),
      firstDate: _fechaInicio ?? DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (picked != null && picked != _fechaFin) {
      setState(() {
        _fechaFin = picked;
      });
    }
  }

  Future<void> _realizarReserva() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Validar fechas
      if (_fechaInicio == null || _fechaFin == null) {
        throw Exception('Por favor selecciona ambas fechas.');
      }

      if (_fechaInicio!.isAfter(_fechaFin!)) {
        throw Exception('La fecha de inicio no puede ser posterior a la fecha de fin.');
      }

      // Calcular la cantidad de noches
      final noches = _fechaFin!.difference(_fechaInicio!).inDays;
      if (noches <= 0) {
        throw Exception('La estadía debe ser de al menos 1 noche.');
      }

      // Obtener ID del cliente desde SharedPreferences
      final clienteInfo = await AuthService.getClienteInfo();
      if (clienteInfo == null) throw Exception('Usuario no autenticado.');

      final clienteId = clienteInfo['id'];

      // Calcular precios
      final precioNoches = noches * double.parse(widget.lugar['precioNoche']);
      final costoLimpieza = double.parse(widget.lugar['costoLimpieza']);
      final precioServicio = 0.1 * precioNoches; // Ejemplo: 10% del precio total por noches
      final precioTotal = precioNoches + costoLimpieza + precioServicio;

      // Llamar al servicio de reserva
      await ReservaService.createReserva(
        lugarId: widget.lugar['id'],
        clienteId: clienteId,
        fechaInicio: DateFormat('yyyy-MM-dd').format(_fechaInicio!),
        fechaFin: DateFormat('yyyy-MM-dd').format(_fechaFin!),
        precioTotal: precioTotal.toStringAsFixed(2),
        precioLimpieza: costoLimpieza.toStringAsFixed(2),
        precioNoches: precioNoches.toStringAsFixed(2),
        precioServicio: precioServicio.toStringAsFixed(2),
      );

      // Mostrar éxito y regresar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva realizada con éxito.')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar la reserva: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Reservar - ${widget.lugar['nombre']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selección de fecha de inicio
            GestureDetector(
              onTap: _selectFechaInicio,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Fecha de Inicio',
                    hintText: _fechaInicio != null
                        ? DateFormat('yyyy-MM-dd').format(_fechaInicio!)
                        : 'Selecciona una fecha',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Selección de fecha de fin
            GestureDetector(
              onTap: _selectFechaFin,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Fecha de Fin',
                    hintText: _fechaFin != null
                        ? DateFormat('yyyy-MM-dd').format(_fechaFin!)
                        : 'Selecciona una fecha',
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.0),

            // Botón para confirmar reserva
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _realizarReserva,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text(
                        'Confirmar Reserva',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

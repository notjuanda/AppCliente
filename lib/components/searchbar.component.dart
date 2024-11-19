import 'package:flutter/material.dart';
import 'package:airbnbcliente/services/lugar.service.dart';

class SearchBar extends StatefulWidget {
  final Function(List<dynamic>) onSearchResults;

  SearchBar({required this.onSearchResults});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _cityController = TextEditingController();
  int _cantCamas = 0;
  int _cantBanios = 0;
  int _cantHabitaciones = 0;
  int _tieneWifi = 0;
  int _cantVehiculosParqueo = 0;
  double _precioNoche = 0.0;

  bool _isLoading = false;
  bool _isAdvancedVisible = true; // Control del estado del componente completo

  void _updateCounter(String field, bool isIncrement) {
    setState(() {
      if (field == 'camas') {
        _cantCamas = isIncrement ? _cantCamas + 1 : (_cantCamas > 0 ? _cantCamas - 1 : 0);
      } else if (field == 'banios') {
        _cantBanios = isIncrement ? _cantBanios + 1 : (_cantBanios > 0 ? _cantBanios - 1 : 0);
      } else if (field == 'habitaciones') {
        _cantHabitaciones = isIncrement ? _cantHabitaciones + 1 : (_cantHabitaciones > 0 ? _cantHabitaciones - 1 : 0);
      } else if (field == 'vehiculos') {
        _cantVehiculosParqueo = isIncrement
            ? _cantVehiculosParqueo + 1
            : (_cantVehiculosParqueo > 0 ? _cantVehiculosParqueo - 1 : 0);
      }
    });
  }

  Future<void> _searchPlaces() async {
    setState(() {
      _isLoading = true;
    });

    final requestPayload = {
      'ciudad': _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : "",
      'cantCamas': _cantCamas > 0 ? _cantCamas.toString() : "",
      'cantBanios': _cantBanios > 0 ? _cantBanios.toString() : "",
      'cantHabitaciones': _cantHabitaciones > 0 ? _cantHabitaciones.toString() : "",
      'tieneWifi': _tieneWifi > 0 ? "1" : "",
      'cantVehiculosParqueo': _cantVehiculosParqueo > 0 ? _cantVehiculosParqueo.toString() : "",
      'precioNoche': _precioNoche > 0 ? _precioNoche.toString() : "",
    };

    try {
      final results = await LugarService.advancedSearchLugares(
        ciudad: requestPayload['ciudad']!,
        cantCamas: requestPayload['cantCamas']!,
        cantBanios: requestPayload['cantBanios']!,
        cantHabitaciones: requestPayload['cantHabitaciones']!,
        tieneWifi: requestPayload['tieneWifi']!,
        cantVehiculosParqueo: requestPayload['cantVehiculosParqueo']!,
        precioNoche: requestPayload['precioNoche']!,
      );

      if (results is List) {
        widget.onSearchResults(results);
      } else if (results is Map<String, dynamic>) {
        widget.onSearchResults(results['data'] ?? []);
      } else {
        throw Exception('Formato de respuesta no soportado');
      }

      setState(() {
        _isAdvancedVisible = false; // Ocultar búsqueda avanzada después de buscar
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isAdvancedVisible) {
          setState(() {
            _isAdvancedVisible = true; // Mostrar todo el componente al presionar cuando está oculto
          });
        }
      },
      child: Column(
        children: [
          TextField(
            controller: _cityController,
            readOnly: !_isAdvancedVisible, // Solo editable si la búsqueda avanzada está visible
            decoration: InputDecoration(
              labelText: 'Ciudad',
              prefixIcon: Icon(Icons.location_city),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onTap: () {
              if (!_isAdvancedVisible) {
                setState(() {
                  _isAdvancedVisible = true; // Mostrar todo al hacer clic en "Ciudad"
                });
              }
            },
          ),
          if (_isAdvancedVisible) ...[
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCounterControl('Camas', _cantCamas, 'camas'),
                _buildCounterControl('Baños', _cantBanios, 'banios'),
                _buildCounterControl('Habitaciones', _cantHabitaciones, 'habitaciones'),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCounterControl('Vehículos Parqueo', _cantVehiculosParqueo, 'vehiculos'),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '¿Tiene WiFi?',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _tieneWifi == 1,
                  onChanged: (value) {
                    setState(() {
                      _tieneWifi = value ? 1 : 0;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Precio por noche: \$${_precioNoche.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _precioNoche,
                  min: 0,
                  max: 1000,
                  divisions: 100,
                  label: '\$${_precioNoche.toStringAsFixed(0)}',
                  onChanged: (value) {
                    setState(() {
                      _precioNoche = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _searchPlaces,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Buscar',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCounterControl(String label, int count, String field) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => _updateCounter(field, false),
              icon: Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$count',
              style: TextStyle(fontSize: 16.0),
            ),
            IconButton(
              onPressed: () => _updateCounter(field, true),
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}

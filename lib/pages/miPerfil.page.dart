import 'package:flutter/material.dart';
import 'package:airbnbcliente/services/auth.service.dart';
import 'package:flutter/cupertino.dart';

class MiPerfilPage extends StatefulWidget {
  @override
  _MiPerfilPageState createState() => _MiPerfilPageState();
}

class _MiPerfilPageState extends State<MiPerfilPage> {
  Map<String, dynamic>? clienteInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClienteInfo();
  }

  Future<void> _fetchClienteInfo() async {
    try {
      final data = await AuthService.getClienteInfo();
      if (data == null) {
        throw Exception('No se pudo obtener la información del cliente.');
      }
      setState(() {
        clienteInfo = data;
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await AuthService.logoutCliente();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mi Perfil'),
          backgroundColor: Colors.black,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (clienteInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mi Perfil'),
          backgroundColor: Colors.black,
        ),
        body: Center(child: Text('No se pudo cargar la información del cliente.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 20),
            Text(
              clienteInfo!['nombrecompleto'] ?? 'Nombre no disponible',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              clienteInfo!['email'] ?? 'Correo no disponible',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Divider(thickness: 1, color: Colors.grey[400]),
            SizedBox(height: 16),
            _buildInfoRow(Icons.phone, 'Teléfono', clienteInfo!['telefono'] ?? 'No disponible'),
            _buildInfoRow(Icons.date_range, 'Fecha de creación',
                clienteInfo!['created_at']?.substring(0, 10) ?? 'No disponible'),
            SizedBox(height: 20),
            Divider(thickness: 1, color: Colors.grey[400]),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
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

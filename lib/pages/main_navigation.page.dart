import 'package:airbnbcliente/pages/reservas.page.dart';
import 'package:airbnbcliente/pages/miPerfil.page.dart'; // Importa la nueva página de perfil
import 'package:flutter/material.dart';
import 'home.page.dart';

class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    HomePage(), // Página principal
    ReservasPage(), // Nueva página de reservas
    MiPerfilPage(), // Página de perfil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Página activa según el índice seleccionado
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark), // Ícono para reservas
            label: 'Mis Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Ícono para perfil
            label: 'Mi Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Color del ítem seleccionado
        onTap: _onItemTapped,
      ),
    );
  }
}

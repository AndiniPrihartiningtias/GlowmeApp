import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🔥 TOP NAVBAR
      appBar: AppBar(
        title: const Text("GlowMe"),
        centerTitle: true,
        backgroundColor: Color(0xFFFFE7EE),
        elevation: 0,
      ),

      /// 🔥 BODY (simple placeholder)
      body: Center(
        child: Text(
          "Home Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      /// 🔥 BOTTOM NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFFFFE7EE),
        selectedItemColor: Color(0xFFFF4A80),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

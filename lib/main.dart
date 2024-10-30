import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd6_b_1815/database/sql_helper2.dart';
import 'package:gd6_b_1815/database/sql_helper.dart';
import 'package:gd6_b_1815/inputPage.dart';
import 'package:gd6_b_1815/inputRegion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'SQFLITE'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> employee = [];
  List<Map<String, dynamic>> region = [];

  void refreshEmployee() async {
    final data = await SQLHelper.getEmployee();
    setState(() {
      employee = data;
    });
  }

  void refreshRegion() async {
    final data = await SQLHelper2.getRegion();
    setState(() {
      region = data;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshEmployee();
    refreshRegion();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "EMPLOYEE" : "REGION"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              if (_selectedIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Inputpage(
                      title: 'INPUT EMPLOYEE',
                      id: null,
                      name: null,
                      email: null,
                    ),
                  ),
                ).then((_) => refreshEmployee());
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Inputregion(
                      title: 'INPUT REGION',
                      idRegion: null,
                      gajiUMR: null,
                      kota: null,
                    ),
                  ),
                ).then((_) => refreshRegion());
              }
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 ? buildEmployeeList() : buildRegion(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Employee',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Region',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildEmployeeList() {
    return ListView.builder(
      itemCount: employee.length,
      itemBuilder: (context, index) {
        return Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Inputpage(
                        title: 'INPUT EMPLOYEE',
                        id: employee[index]['id'],
                        name: employee[index]['name'],
                        email: employee[index]['email'],
                      ),
                    ),
                  ).then((_) => refreshEmployee());
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.update,
                label: 'Update',
              ),
              SlidableAction(
                onPressed: (context) async {
                  await SQLHelper.deleteEmployee(employee[index]['id']);
                  refreshEmployee();
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: Text(employee[index]['name']),
            subtitle: Text(employee[index]['email']),
          ),
        );
      },
    );
  }

  Widget buildRegion() {
    return ListView.builder(
      itemCount: region.length,
      itemBuilder: (context, index) {
        return Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Inputregion(
                        title: 'INPUT REGION',
                        idRegion: region[index]['idRegion'],
                        kota: region[index]['kota'] ?? '', // Nilai default jika null
                        gajiUMR: region[index]['gajiUMR']?.toString() ?? '', // Mengonversi ke string dan memberi nilai default
                      ),
                    ),
                  ).then((_) => refreshRegion());
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.update,
                label: 'Update',
              ),
              SlidableAction(
                onPressed: (context) async {
                  await SQLHelper2.deleteRegion(region[index]['idRegion']);
                  refreshRegion();
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: Text(region[index]['kota'] ?? 'Unknown'),
            subtitle: Text(region[index]['gajiUMR']?.toString() ?? 'Unknown'), // Mengonversi ke string dan memberi nilai default
          ),
        );
      },
    );
  }
}

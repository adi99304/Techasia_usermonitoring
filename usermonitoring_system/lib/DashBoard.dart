import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TechAsia Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text('Profile'),
              onTap: () {
                // Handle Profile navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail, color: Colors.black),
              title: Text('Contact Us'),
              onTap: () {
                // Handle Contact Us navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('Logout'),
              onTap: () {
                // Handle Logout
              },
            ),
          ],
        ),
      ),
      body: DataControlScreen(),
    );
  }
}

class DataControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Data Control',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DataTableScreen(
                                editable: false, fetchData: true),
                          ),
                        );
                      },
                      child: Text('View Data'),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DataTableScreen(
                                editable: true, fetchData: false),
                          ),
                        );
                      },
                      child: Text('Edit Data'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class DataTableScreen extends StatefulWidget {
  final bool editable;
  final bool fetchData;

  DataTableScreen({this.editable = false, this.fetchData = false});

  @override
  _DataTableScreenState createState() => _DataTableScreenState();
}

class _DataTableScreenState extends State<DataTableScreen> {
  static const int initialColumns = 14;
  List<TextEditingController> _headerControllers =
      List.generate(initialColumns, (_) => TextEditingController());
  List<List<TextEditingController>> _controllers = List.generate(
      10, (_) => List.generate(initialColumns, (_) => TextEditingController()));

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < initialColumns; i++) {
      _headerControllers[i].text = String.fromCharCode(65 + i); // A, B, C, ...
    }
    if (widget.fetchData) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/get-data'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _controllers.clear();
          for (var row in data) {
            List<TextEditingController> rowControllers = [];
            for (int i = 0; i < initialColumns; i++) {
              String columnName = String.fromCharCode(65 + i);
              rowControllers
                  .add(TextEditingController(text: row[columnName] ?? ''));
            }
            _controllers.add(rowControllers);
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _addRow() {
    setState(() {
      _controllers
          .add(List.generate(initialColumns, (_) => TextEditingController()));
    });
  }

  Widget _buildCell(TextEditingController controller, bool isHeader) {
    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: isHeader ? Colors.grey.shade200 : Colors.white,
      ),
      child: TextField(
        controller: controller,
        enabled: widget.editable,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < _controllers.length; i++) {
      for (int j = 0; j < initialColumns; j++) {
        data.add({
          'row_number': i + 1,
          'column_name': String.fromCharCode(65 + j),
          'value': _controllers[i][j].text,
        });
      }
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/save-data'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'data': data}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved successfully!')),
        );
      } else {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Table'),
        actions: [
          if (widget.editable)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addRow,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.grey.shade200,
                        ),
                        child: Center(child: Text('')),
                      ),
                      ...List.generate(
                          initialColumns,
                          (index) =>
                              _buildCell(_headerControllers[index], true)),
                    ],
                  ),
                  // Data rows
                  ...List.generate(_controllers.length, (rowIndex) {
                    return Row(
                      children: [
                        Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.grey.shade200,
                          ),
                          child: Center(child: Text('${rowIndex + 1}')),
                        ),
                        ...List.generate(
                            initialColumns,
                            (colIndex) => _buildCell(
                                _controllers[rowIndex][colIndex], false)),
                      ],
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (widget.editable)
              Center(
                child: ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Save'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

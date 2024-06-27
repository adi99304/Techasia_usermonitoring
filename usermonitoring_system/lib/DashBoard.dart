import 'package:flutter/material.dart';

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
      backgroundColor: Colors.black
      ,
    
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
      backgroundColor: Colors.black,
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
                              builder: (context) => DataTableScreen()),
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
                              builder: (context) =>
                                  DataTableScreen(editable: true)),
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

  DataTableScreen({this.editable = false});

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
      backgroundColor: Colors.black,
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
                  onPressed: () {
                    // Implement save functionality here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data saved!')),
                    );
                  },
                  child: Text('Save'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

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
      home: DataTableScreen(
          editable: true), // Set this to false to disable editing
    );
  }
}

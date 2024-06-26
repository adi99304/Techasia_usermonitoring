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
              leading: Icon(Icons.person, color: Colors.white),
              title: Text('Profile'),
              onTap: () {
                // Handle Profile navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail, color: Colors.white),
              title: Text('Contact Us'),
              onTap: () {
                // Handle Contact Us navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
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
  List<TextEditingController> _headerControllers =
      List.generate(12, (_) => TextEditingController());
  List<List<TextEditingController>> _controllers = List.generate(
    10,
    (_) => List.generate(12, (_) => TextEditingController()),
  );

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 12; i++) {
      _headerControllers[i].text = 'Col $i';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DataTable(
                columns: List<DataColumn>.generate(12, (index) {
                  return DataColumn(
                    label: widget.editable
                        ? TextField(
                            controller: _headerControllers[index],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Col $index',
                              hintStyle: TextStyle(color: Colors.white24),
                            ),
                          )
                        : Text(
                            _headerControllers[index].text.isEmpty
                                ? 'Col $index'
                                : _headerControllers[index].text,
                            style: TextStyle(color: Colors.white),
                          ),
                  );
                }),
                rows: List<DataRow>.generate(10, (rowIndex) {
                  return DataRow(
                    cells: List<DataCell>.generate(12, (colIndex) {
                      bool isFirstRow = rowIndex == 0;
                      return DataCell(
                        widget.editable
                            ? TextField(
                                controller: _controllers[rowIndex][colIndex],
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: isFirstRow
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Item $colIndex',
                                  hintStyle: TextStyle(color: Colors.white24),
                                ),
                              )
                            : Text(
                                _controllers[rowIndex][colIndex].text.isEmpty
                                    ? 'Item $colIndex'
                                    : _controllers[rowIndex][colIndex].text,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: isFirstRow
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                      );
                    }),
                  );
                }),
              ),
              SizedBox(height: 16.0),
              if (widget.editable)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement save functionality here
                      // For demonstration, we'll just print the values
                      for (int i = 0; i < 12; i++) {
                        print('Header $i: ${_headerControllers[i].text}');
                      }
                      for (int i = 0; i < 10; i++) {
                        for (int j = 0; j < 12; j++) {
                          print(
                              'Row $i, Column $j: ${_controllers[i][j].text}');
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Data saved!'),
                        ),
                      );
                    },
                    child: Text('Save'),
                  ),
                ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

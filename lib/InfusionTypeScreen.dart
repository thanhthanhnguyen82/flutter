import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class InfusionType {
  String? id;
  String name;
  String volume;
  String transmissionSpeed;

  InfusionType({
    this.id,
    required this.name,
    required this.volume,
    required this.transmissionSpeed,
  });
}

class InfusionTypeScreen extends StatefulWidget {
  @override
  _InfusionTypeScreenState createState() => _InfusionTypeScreenState();
}

class _InfusionTypeScreenState extends State<InfusionTypeScreen> {
  final DatabaseReference infusionTypesRef =
      FirebaseDatabase.instance.reference().child('infusion_types');

  List<InfusionType> infusionTypesList = [];
  bool _isMounted = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController volumeController = TextEditingController();
  TextEditingController speedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadInfusionTypes();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _loadInfusionTypes() {
    infusionTypesRef.onValue.listen((event) {
      try {
        if (_isMounted && event.snapshot.value != null) {
          Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            infusionTypesList = values.entries.map((entry) {
              return InfusionType(
                id: entry.key,
                name: entry.value['name'],
                volume: entry.value['volume'],
                transmissionSpeed: entry.value['transmissionSpeed'],
              );
            }).toList();
          });
        }
      } catch (e) {
        print('Error loading data: $e');
      }
    });
  }

  void addInfusionType() {
    String newName = nameController.text;
    String newVolume = volumeController.text;
    String newSpeed = speedController.text;

    DatabaseReference newInfusionTypeRef = infusionTypesRef.push();
    newInfusionTypeRef.set({
      'name': newName,
      'volume': newVolume,
      'transmissionSpeed': newSpeed,
    });

    if (_isMounted) {
      setState(() {
        infusionTypesList.add(
          InfusionType(
            id: newInfusionTypeRef.key!,
            name: newName,
            volume: newVolume,
            transmissionSpeed: newSpeed,
          ),
        );
      });
    }

    nameController.clear();
    volumeController.clear();
    speedController.clear();
  }

  void updateInfusionType(InfusionType infusionType) {
    // Replace this with your actual implementation for updating
    print('Updating Infusion Type: ${infusionType.name}');
  }

  void deleteInfusionType(InfusionType infusionType) {
    // Replace this with your actual implementation for deleting
    print('Deleting Infusion Type: ${infusionType.name}');
  }

  Future<void> showAddDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm Loại Dịch'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên Dịch Truyền'),
              ),
              TextField(
                controller: volumeController,
                decoration: InputDecoration(labelText: 'Thể Tích'),
              ),
              TextField(
                controller: speedController,
                decoration: InputDecoration(labelText: 'Tốc Độ Truyền'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                addInfusionType();
                Navigator.of(context).pop();
              },
              child: Text('Thêm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showUpdateDialog(BuildContext context, InfusionType infusionType) async {
    nameController.text = infusionType.name;
    volumeController.text = infusionType.volume;
    speedController.text = infusionType.transmissionSpeed;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chỉnh Sửa Loại Dịch'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên Dịch Truyền'),
              ),
              TextField(
                controller: volumeController,
                decoration: InputDecoration(labelText: 'Thể Tích'),
              ),
              TextField(
                controller: speedController,
                decoration: InputDecoration(labelText: 'Tốc Độ Truyền'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                updateInfusionType(infusionType);
                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteDialog(BuildContext context, InfusionType infusionType) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa Loại Dịch'),
          content: Text('Bạn có chắc chắn muốn xóa loại dịch này?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                deleteInfusionType(infusionType);
                Navigator.of(context).pop();
              },
              child: Text('Xóa'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loại Dịch Truyền'),
      ),
      body: Column(
        children: [
          DataTable(
            columns: [
              DataColumn(label: Text('Tên Dịch Truyền')),
              DataColumn(label: Text('Thể Tích')),
              DataColumn(label: Text('Tốc Độ Truyền')),
              DataColumn(label: Text('Chỉnh Sửa / Xóa')),
            ],
            rows: infusionTypesList.map((infusionType) {
              return DataRow(cells: [
                DataCell(Text(infusionType.name)),
                DataCell(Text(infusionType.volume)),
                DataCell(Text(infusionType.transmissionSpeed)),
                DataCell(
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showUpdateDialog(context, infusionType);
                        },
                        child: Text('Chỉnh Sửa'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          showDeleteDialog(context, infusionType);
                        },
                        child: Text('Xóa'),
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              showAddDialog(context);
            },
            child: Text('Thêm Loại Dịch'),
          ),
        ],
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
      home: InfusionTypeScreen(),
    );
  }
}

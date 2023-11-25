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
          title: Text('Thêm Loại Dịch', style: TextStyle(color: Colors.deepPurple)),
          content: Column(
            children: [
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên Dịch Truyền', fillColor: Colors.deepPurple),
              ),
              SizedBox(height: 16),
              TextField(
                controller: volumeController,
                decoration: InputDecoration(labelText: 'Thể Tích', fillColor: Colors.deepPurple),
              ),
              SizedBox(height: 16),
              TextField(
                controller: speedController,
                decoration: InputDecoration(labelText: 'Tốc Độ Truyền', fillColor: Colors.deepPurple),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                addInfusionType();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
              child: Text('Thêm', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy', style: TextStyle(color: Colors.deepPurple)),
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
          title: Text('Chỉnh Sửa Loại Dịch', style: TextStyle(color: Colors.deepOrange)),
          content: Column(
            children: [
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên Dịch Truyền', fillColor: Colors.deepOrange),
              ),
              SizedBox(height: 16),
              TextField(
                controller: volumeController,
                decoration: InputDecoration(labelText: 'Thể Tích', fillColor: Colors.deepOrange),
              ),
              SizedBox(height: 16),
              TextField(
                controller: speedController,
                decoration: InputDecoration(labelText: 'Tốc Độ Truyền', fillColor: Colors.deepOrange),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                updateInfusionType(infusionType);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
              child: Text('Lưu', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy', style: TextStyle(color: Colors.deepOrange)),
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
          title: Text('Xóa Loại Dịch', style: TextStyle(color: Colors.red)),
          content: Text('Bạn có chắc chắn muốn xóa loại dịch này?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                deleteInfusionType(infusionType);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy', style: TextStyle(color: Colors.red)),
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
        title: Text('Loại Dịch Truyền', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          DataTable(
            columns: [
              DataColumn(label: Text('Tên Dịch Truyền', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(label: Text('Thể Tích', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(label: Text('Tốc Độ Truyền', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(label: Text('Chỉnh Sửa / Xóa', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
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
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                        child: Text('Chỉnh Sửa', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          showDeleteDialog(context, infusionType);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: Text('Xóa', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showAddDialog(context);
            },
            style: ElevatedButton.styleFrom(primary: Colors.purple),
            child: Text('Thêm Loại Dịch', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}


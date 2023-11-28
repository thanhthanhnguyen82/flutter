import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final CollectionReference infusionTypesRef =
      FirebaseFirestore.instance.collection('infusion_types');

  List<InfusionType> infusionTypesList = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController volumeController = TextEditingController();
  TextEditingController speedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInfusionTypes();
  }

  void _loadInfusionTypes() {
    infusionTypesRef.snapshots().listen((snapshot) {
      setState(() {
        infusionTypesList = snapshot.docs.map((doc) {
          return InfusionType(
            id: doc.id,
            name: doc['name'],
            volume: doc['volume'],
            transmissionSpeed: doc['transmissionSpeed'],
          );
        }).toList();
      });
    });
  }

  void addInfusionType() {
    String newName = nameController.text;
    String newVolume = volumeController.text;
    String newSpeed = speedController.text;

    infusionTypesRef.add({
      'name': newName,
      'volume': newVolume,
      'transmissionSpeed': newSpeed,
    });

    nameController.clear();
    volumeController.clear();
    speedController.clear();
  }

  void updateInfusionType(InfusionType infusionType) {
    String documentId = infusionType.id!;
    String updatedName = nameController.text;
    String updatedVolume = volumeController.text;
    String updatedSpeed = speedController.text;

    infusionTypesRef.doc(documentId).update({
      'name': updatedName,
      'volume': updatedVolume,
      'transmissionSpeed': updatedSpeed,
    });

    nameController.clear();
    volumeController.clear();
    speedController.clear();
  }

  void deleteInfusionType(InfusionType infusionType) {
    String documentId = infusionType.id!;
    infusionTypesRef.doc(documentId).delete();
  }

  Future<void> showAddDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm Loại Dịch',
              style: TextStyle(color: Colors.deepPurple)),
          content: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Tên Dịch Truyền', fillColor: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: volumeController,
                decoration: const InputDecoration(
                    labelText: 'Thể Tích', fillColor: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: speedController,
                decoration: const InputDecoration(
                    labelText: 'Tốc Độ Truyền', fillColor: Colors.deepPurple),
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
              child: const Text('Thêm', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Hủy', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        );
      },
    );
  }

  Future<void> showUpdateDialog(
      BuildContext context, InfusionType infusionType) async {
    nameController.text = infusionType.name;
    volumeController.text = infusionType.volume;
    speedController.text = infusionType.transmissionSpeed;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chỉnh Sửa Loại Dịch',
              style: TextStyle(color: Colors.deepOrange)),
          content: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Tên Dịch Truyền', fillColor: Colors.deepOrange),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: volumeController,
                decoration: const InputDecoration(
                    labelText: 'Thể Tích', fillColor: Colors.deepOrange),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: speedController,
                decoration: const InputDecoration(
                    labelText: 'Tốc Độ Truyền', fillColor: Colors.deepOrange),
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
              child: const Text('Lưu', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Hủy', style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteDialog(
      BuildContext context, InfusionType infusionType) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Xóa Loại Dịch', style: TextStyle(color: Colors.red)),
          content: const Text('Bạn có chắc chắn muốn xóa loại dịch này?'),
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
        title: const Text('Loại Dịch Truyền',
            style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 161, 81, 75),
      ),
      body: Column(
        children: [
          DataTable(
            columns: const [
              DataColumn(
                  label: Text('Tên Dịch Truyền',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text('Thể Tích',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text('Tốc Độ Truyền',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text('Chỉnh Sửa / Xóa',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
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
                        child: const Text('Chỉnh Sửa',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          showDeleteDialog(context, infusionType);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: const Text('Xóa',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showAddDialog(context);
            },
            style: ElevatedButton.styleFrom(primary: Colors.purple),
            child: const Text('Thêm Loại Dịch',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

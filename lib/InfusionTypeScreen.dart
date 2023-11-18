import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfusionType {
  String id;
  String name;
  String volume;
  String transmissionSpeed;

  InfusionType({
    required this.id,
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
  final CollectionReference infusionTypes =
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

  Future<void> _loadInfusionTypes() async {
    QuerySnapshot infusionTypesSnapshot = await infusionTypes.get();
    setState(() {
      infusionTypesList = infusionTypesSnapshot.docs.map((doc) {
        return InfusionType(
          id: doc.id,
          name: doc['name'],
          volume: doc['volume'],
          transmissionSpeed: doc['transmissionSpeed'],
        );
      }).toList();
    });
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
              DataColumn(label: Text('Chỉnh Sửa / xóa')),
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

  void showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
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

  void showUpdateDialog(BuildContext context, InfusionType infusionType) {
    nameController.text = infusionType.name;
    volumeController.text = infusionType.volume;
    speedController.text = infusionType.transmissionSpeed;

    showDialog(
      context: context,
      builder: (context) {
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

  void showDeleteDialog(BuildContext context, InfusionType infusionType) {
    showDialog(
      context: context,
      builder: (context) {
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

  void addInfusionType() {
    String newName = nameController.text;
    String newVolume = volumeController.text;
    String newSpeed = speedController.text;

    infusionTypes.add({
      'name': newName,
      'volume': newVolume,
      'transmissionSpeed': newSpeed,
    });

    setState(() {
      infusionTypesList.add(
        InfusionType(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: newName,
          volume: newVolume,
          transmissionSpeed: newSpeed,
        ),
      );
    });

    nameController.clear();
    volumeController.clear();
    speedController.clear();
  }

  void updateInfusionType(InfusionType infusionType) {
    String newName = nameController.text;
    String newVolume = volumeController.text;
    String newSpeed = speedController.text;

    infusionTypes.doc(infusionType.id).update({
      'name': newName,
      'volume': newVolume,
      'transmissionSpeed': newSpeed,
    });

    setState(() {
      int index = infusionTypesList
          .indexWhere((element) => element.id == infusionType.id);
      if (index != -1) {
        infusionTypesList[index] = InfusionType(
          id: infusionType.id,
          name: newName,
          volume: newVolume,
          transmissionSpeed: newSpeed,
        );
      }
    });

    nameController.clear();
    volumeController.clear();
    speedController.clear();
  }

  void deleteInfusionType(InfusionType infusionType) {
    infusionTypes.doc(infusionType.id).delete();

    setState(() {
      infusionTypesList.removeWhere((element) => element.id == infusionType.id);
    });
  }
}

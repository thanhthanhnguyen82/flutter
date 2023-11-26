import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPatientScreen extends StatefulWidget {
  final String initialPatientName;
  final String truyenDich;
  final String tocdotruyen;
  final String dungtichbinh;
  final String documentId;

  EditPatientScreen(
    this.initialPatientName,
    this.truyenDich,
    this.tocdotruyen,
    this.dungtichbinh,
    this.documentId,
  );

  @override
  _EditPatientScreenState createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  late TextEditingController _nameController;
  late TextEditingController _infusionTypeController;
  late TextEditingController _tocdotruyenController;
  late TextEditingController _dungtichbinhController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialPatientName);
    _infusionTypeController =
        TextEditingController(text: widget.truyenDich);
    _tocdotruyenController =
        TextEditingController(text: widget.tocdotruyen);
    _dungtichbinhController =
        TextEditingController(text: widget.dungtichbinh);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _infusionTypeController.dispose();
    _tocdotruyenController.dispose();
    _dungtichbinhController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa thông tin bệnh nhân'),
        backgroundColor: const Color.fromARGB(255, 161, 81, 75),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên bệnh nhân'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _infusionTypeController,
              decoration: InputDecoration(labelText: 'Loại dịch truyền'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _tocdotruyenController,
              decoration: InputDecoration(labelText: 'Tốc độ truyền'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dungtichbinhController,
              decoration: InputDecoration(labelText: 'Dung tích bình'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updatePatient();
              },
              child: Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePatient() {
    FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.documentId)
        .update({
      'name': _nameController.text,
      'infusionType': _infusionTypeController.text,
      'tocdotruyen': _tocdotruyenController.text,
      'dungtichbinh': _dungtichbinhController.text,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      print('Lỗi cập nhật thông tin bệnh nhân: $error');
    });
  }
}

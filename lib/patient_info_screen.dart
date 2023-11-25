import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientInfoScreen extends StatefulWidget {
  String initialPatientName;
  String truyenDich;
  String tocdotruyen;
  String dungtichbinh;
  PatientInfoScreen(this.initialPatientName, this.truyenDich, this.tocdotruyen, this.dungtichbinh);
  @override
  _PatientInfoScreenState createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _infusionTypeController = TextEditingController();
  final TextEditingController _tocDoTruyenController = TextEditingController();
  final TextEditingController _dungtichbinhController = TextEditingController();

  final CollectionReference patients = FirebaseFirestore.instance.collection('patients');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin bệnh nhân'),
      ),
      body: ListView(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              _showAddPatientDialog(context);
            },
            child: Text('Thêm bệnh nhân mới'),
          ),
          ElevatedButton(
            onPressed: () {
              _showPatientList(context);
            },
            child: Text('Danh sách bệnh nhân'),
          ),
        ],
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm bệnh nhân mới'),
          content: Column(
            children: [
              TextField(
                controller: _patientNameController,
                decoration: InputDecoration(labelText: 'Tên bệnh nhân'),
              ),
              TextField(
                controller: _infusionTypeController,
                decoration: InputDecoration(labelText: 'Loại dịch truyền'),
              ),
              TextField(
                controller: _tocDoTruyenController,
                decoration: InputDecoration(labelText: 'Tốc độ truyền'),
              ),
              TextField(
                controller: _dungtichbinhController,
                decoration: InputDecoration(labelText: 'Dung tích bình'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _savePatientInfo();
                Navigator.pop(context);
              },
              child: Text('Lưu thông tin'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  void _savePatientInfo() {
    String patientName = _patientNameController.text;
    String infusionType = _infusionTypeController.text;
    String tocDoTruyen = _tocDoTruyenController.text;
    String dungTichBinh = _dungtichbinhController.text;

    if (patientName.isNotEmpty && infusionType.isNotEmpty && tocDoTruyen.isNotEmpty && dungTichBinh.isNotEmpty) {
      patients.add({
        'name': patientName,
        'infusionType': infusionType,
        'tocdotruyen': tocDoTruyen,
        'dungtichbinh': dungTichBinh,
      }).then((value) {
        _showSuccessMessage('Đã thêm bệnh nhân mới: $patientName, $infusionType, $tocDoTruyen, $dungTichBinh');
      }).catchError((error) {
        _showErrorMessage('Đã xảy ra lỗi khi thêm bệnh nhân: $error');
      });
    } else {
      _showErrorMessage('Vui lòng nhập đầy đủ thông tin');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showPatientList(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Danh sách bệnh nhân'),
          content: StreamBuilder<QuerySnapshot>(
            stream: patients.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Đã xảy ra lỗi: ${snapshot.error}');
              }

              List<QueryDocumentSnapshot> patients = snapshot.data!.docs;

              return SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('STT')),
                    DataColumn(label: Text('Tên bệnh nhân')),
                  ],
                  rows: patients.map((patient) {
                    return DataRow(cells: [
                      DataCell(Text('${patients.indexOf(patient) + 1}')),
                      DataCell(Text('${patient['name']}')),
                    ]);
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}

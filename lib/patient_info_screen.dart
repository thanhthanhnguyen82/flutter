import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
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
        backgroundColor: const Color.fromARGB(255, 161, 81, 75),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16),
            TextField(
              controller: _patientNameController,
              decoration: InputDecoration(labelText: 'Tên bệnh nhân', fillColor: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _infusionTypeController,
              decoration: InputDecoration(labelText: 'Loại dịch truyền', fillColor: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _tocDoTruyenController,
              decoration: InputDecoration(labelText: 'Tốc độ truyền', fillColor: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dungtichbinhController,
              decoration: InputDecoration(labelText: 'Dung tích bình', fillColor: Colors.white),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _savePatientInfo();
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text('Lưu thông tin', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showPatientList(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text('Danh sách bệnh nhân', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
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
        title: Text('Danh sách bệnh nhân', style: TextStyle(color: Colors.black)),
        content: StreamBuilder<QuerySnapshot>(
          stream: patients.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError || snapshot.data == null) {
              return Text('Đã xảy ra lỗi hoặc dữ liệu rỗng: ${snapshot.error}');
            }

            List<QueryDocumentSnapshot> patients = snapshot.data!.docs;

            return SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))),
                  DataColumn(label: Text('Tên bệnh nhân', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))),
                ],
                rows: patients.map((patient) {
                  return DataRow(cells: [
                    DataCell(Text('${patients.indexOf(patient) + 1}', style: TextStyle(color: Colors.white))),
                    DataCell(Text('${patient['name']}', style: TextStyle(color: Colors.white))),
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
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: Text('Đóng', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
}

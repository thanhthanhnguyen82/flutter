import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientInfoScreen extends StatefulWidget {
  final String initialPatientName;
  final String truyenDich;
  final String tocdotruyen;
  final String dungtichbinh;

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
  void initState() {
    super.initState();
    _patientNameController.text = widget.initialPatientName ?? '';
    _infusionTypeController.text = widget.truyenDich ?? '';
    _tocDoTruyenController.text = widget.tocdotruyen ?? '';
    _dungtichbinhController.text = widget.dungtichbinh ?? '';
  }

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
}

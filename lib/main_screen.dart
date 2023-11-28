import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'menu_screen.dart';
import 'edit_patient_screen.dart'; // Import màn hình sửa thông tin

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý bệnh nhân',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final CollectionReference patients =
      FirebaseFirestore.instance.collection('patients');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách bệnh nhân'),
        backgroundColor: const Color.fromARGB(255, 161, 81, 75),
      ),
      drawer: MenuScreen(),
      body: StreamBuilder<QuerySnapshot>(
        stream: patients.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else {
            List<QueryDocumentSnapshot> patientDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: patientDocs.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.blue[50],
                  child: ListTile(
                    title: Text(
                      'Tên: ${patientDocs[index]['name']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Loại dịch truyền: ${patientDocs[index]['infusionType']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () {
                            _navigateToEditPatient(
                              context,
                              patientDocs[index]['name'],
                              patientDocs[index]['infusionType'],
                              patientDocs[index]['tocdotruyen'],
                              patientDocs[index]['dungtichbinh'],
                              patientDocs[index].id,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            _showDeleteConfirmation(
                                context, patientDocs[index]);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _navigateToPatientInfo(
                        context,
                        patientDocs[index]['name'] ?? '',
                        patientDocs[index]['infusionType'] ?? '',
                        patientDocs[index]['tocdotruyen'] ?? '',
                        patientDocs[index]['dungtichbinh'] ?? '',
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, QueryDocumentSnapshot patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên: ${patient['name']}'),
            Text('Loại dịch truyền: ${patient['infusionType']}'),
            Text('Tốc độ truyền: ${patient['tocdotruyen']}'),
            Text('Dung tích bình: ${patient['dungtichbinh']}'),
            SizedBox(height: 10),
            Text('Bạn có chắc chắn muốn xóa bệnh nhân này?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePatient(patient.id);
            },
            child: Text(
              'Xác nhận',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deletePatient(String documentId) {
    patients.doc(documentId).delete().then((value) {
      print('Bệnh nhân đã bị xóa thành công');
    }).catchError((error) {
      print('Lỗi xóa bệnh nhân: $error');
    });
  }

  void _navigateToEditPatient(
    BuildContext context,
    String initialPatientName,
    String truyenDich,
    String tocdotruyen,
    String dungtichbinh,
    String documentId,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPatientScreen(
          initialPatientName,
          truyenDich,
          tocdotruyen,
          dungtichbinh,
          documentId,
        ),
      ),
    );
  }

  void _navigateToPatientInfo(
    BuildContext context,
    String initialPatientName,
    String truyenDich,
    String tocdotruyen,
    String dungtichbinh,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientInfoScreen(
          initialPatientName,
          truyenDich,
          tocdotruyen,
          dungtichbinh,
        ),
      ),
    );
  }
}

class PatientInfoScreen extends StatelessWidget {
  final String initialPatientName;
  final String truyenDich;
  final String tocdotruyen;
  final String dungtichbinh;

  PatientInfoScreen(
    this.initialPatientName,
    this.truyenDich,
    this.tocdotruyen,
    this.dungtichbinh,
  );

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Tên bệnh nhân: $initialPatientName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Loại dịch truyền: $truyenDich',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Tốc độ truyền: $tocdotruyen', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Dung tích bình: $dungtichbinh',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

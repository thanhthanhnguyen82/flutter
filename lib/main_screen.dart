import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'menu_screen.dart'; // Import your menu_screen.dart

void main() {
  runApp(
    MaterialApp(
      home: MainScreen(),
    ),
  );
}

class MainScreen extends StatelessWidget {
  final CollectionReference patients =
      FirebaseFirestore.instance.collection('patients');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách bệnh nhân'),
      ),
      drawer: MenuScreen(), // Use your MenuScreen here
      body: FutureBuilder<QuerySnapshot>(
        future: patients.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Đã xảy ra lỗi: ${snapshot.error}');
          } else {
            List<QueryDocumentSnapshot> patientDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: patientDocs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Tên: ${patientDocs[index]['name']}'),
                  subtitle: Text(
                    'Loại dịch truyền: ${patientDocs[index]['infusionType']}',
                  ),
                  onTap: () {
                    String initialPatientName = patientDocs[index]['name'] ?? '';
                    String truyenDich = patientDocs[index]['infusionType'] ?? '';
                    String tocdotruyen = patientDocs[index]['tocdotruyen'] ?? '';
                    String dungtichbinh = patientDocs[index]['dungtichbinh'] ?? '';

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
                  },
                );
              },
            );
          }
        },
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
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Tên bệnh nhân: $initialPatientName'),
          ),
          ListTile(
            title: Text('Loại dịch truyền: $truyenDich'),
          ),
          ListTile(
            title: Text('Tốc độ truyền: $tocdotruyen'),
          ),
          ListTile(
            title: Text('Dung tích bình: $dungtichbinh'),
          ),
        ],
      ),
    );
  }
}

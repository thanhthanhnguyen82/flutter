import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'menu_screen.dart';

class MainScreen extends StatelessWidget {
  final CollectionReference patients =
      FirebaseFirestore.instance.collection('patients');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách bệnh nhân'),
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
                return ListTile(
                  title: Text('Tên: ${patientDocs[index]['name']}'),
                  subtitle: Text(
                    'Loại dịch truyền: ${patientDocs[index]['infusionType']}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Xác nhận xóa'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tên: ${patientDocs[index]['name']}'),
                              Text('Loại dịch truyền: ${patientDocs[index]['infusionType']}'),
                              Text('Tốc độ truyền: ${patientDocs[index]['tocdotruyen']}'),
                              Text('Dung tích bình: ${patientDocs[index]['dungtichbinh']}'),
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
                                deletePatient(patientDocs[index].id);
                              },
                              child: Text('Xác nhận'),
                            ),
                          ],
                        ),
                      );
                    },
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

  void deletePatient(String documentId) {
    patients.doc(documentId).delete().then((value) {
      print('Patient deleted successfully');
    }).catchError((error) {
      print('Error deleting patient: $error');
    });
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

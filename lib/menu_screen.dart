import 'package:flutter/material.dart';
import 'patient_info_screen.dart';
import 'InfusionTimeScreen.dart';
import 'InfusionTypeScreen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController patientNameController = TextEditingController();
  TextEditingController truyenDichController = TextEditingController();
  TextEditingController tocDoTruyenController = TextEditingController();
  TextEditingController dungTichBinhController = TextEditingController();

  List<String> patientList = []; // Danh sách bệnh nhân

  void navigateToInfusionType(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfusionTypeScreen()),
    );
  }

  void navigateToInfusionTime(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfusionTimeScreen()),
    );
  }

  void navigateToPatientList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientInfoScreen('', '', '', '')),
    );
  }

  void showAddPatientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm Bệnh Nhân'),
          content: Column(
            children: [
              TextField(
                controller: patientNameController,
                decoration: InputDecoration(labelText: 'Tên Bệnh Nhân'),
              ),
              TextField(
                controller: truyenDichController,
                decoration: InputDecoration(labelText: 'Loại Dịch Truyền'),
              ),
              TextField(
                controller: tocDoTruyenController,
                decoration: InputDecoration(labelText: 'Tốc độ truyền'),
              ),
              TextField(
                controller: dungTichBinhController,
                decoration: InputDecoration(labelText: 'Dung tích bình'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                addNewPatient();
                Navigator.pop(context);
              },
              child: Text('Thêm'),
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

  void addNewPatient() {
    String patientName = patientNameController.text;
    String truyenDich = truyenDichController.text;
    String tocDoTruyen = tocDoTruyenController.text;
    String dungTichBinh = dungTichBinhController.text;

    // Thêm thông tin bệnh nhân vào danh sách
    String patientInfo = '$patientName, $truyenDich, $tocDoTruyen, $dungTichBinh';
    patientList.add(patientInfo);

    // In danh sách bệnh nhân ra console (để kiểm tra)
    print('Danh sách bệnh nhân: $patientList');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Người Dùng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Trang chủ'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              // Xử lý khi nhấp vào "Trang chủ"
            },
          ),
          ListTile(
            title: Text('Danh sách bệnh nhân'),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.pop(context);
              navigateToPatientList(context);
            },
          ),
          ListTile(
            title: Text('Loại Dịch truyền'),
            leading: Icon(Icons.crop_square),
            onTap: () {
              Navigator.pop(context);
              navigateToInfusionType(context);
            },
          ),
          ListTile(
            title: Text('Tộc độ truyền'),
            leading: Icon(Icons.access_time),
            onTap: () {
              Navigator.pop(context);
              navigateToInfusionTime(context);
            },
          ),
          
          
        ],
      ),
    );
  }
}

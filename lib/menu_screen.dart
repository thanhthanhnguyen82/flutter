import 'package:flutter/material.dart';
import 'patient_info_screen.dart';
import 'InfusionTimeScreen.dart';
import 'InfusionTypeScreen.dart';
import 'package:NCKH/screen/signin_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController patientNameController = TextEditingController();
  TextEditingController truyenDichController = TextEditingController();
  TextEditingController tocDoTruyenController = TextEditingController();
  TextEditingController dungTichBinhController = TextEditingController();

  List<String> patientList = [];

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

    String patientInfo = '$patientName, $truyenDich, $tocDoTruyen, $dungTichBinh';
    patientList.add(patientInfo);

    print('Danh sách bệnh nhân: $patientList');
  }

  void handleLogout(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.indigo, // Updated to a vibrant color
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo, // Updated to a vibrant color
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
                      color: Colors.indigoAccent, // Updated to a vibrant color
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
            buildListTile(
              icon: Icons.home,
              title: 'Trang chủ',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            buildListTile(
              icon: Icons.list,
              title: 'Danh sách bệnh nhân',
              onTap: () {
                Navigator.pop(context);
                navigateToPatientList(context);
              },
            ),
            buildListTile(
              icon: Icons.crop_square,
              title: 'Loại Dịch truyền',
              onTap: () {
                Navigator.pop(context);
                navigateToInfusionType(context);
              },
            ),
            buildListTile(
              icon: Icons.access_time,
              title: 'Tốc độ truyền',
              onTap: () {
                Navigator.pop(context);
                navigateToInfusionTime(context);
              },
            ),
            buildListTile(
              icon: Icons.person,
              title: 'Đăng xuất',
              onTap: () {
                Navigator.pop(context);
                handleLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: Icon(icon, color: Colors.white),
      onTap: onTap,
    );
  }
}

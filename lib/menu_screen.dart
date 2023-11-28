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
      MaterialPageRoute(
          builder: (context) => PatientInfoScreen('', '', '', '')),
    );
  }


  void handleLogout(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.indigo, // Updated to a vibrant color
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
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
              title: 'Thêm bệnh nhân',
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

  ListTile buildListTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
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

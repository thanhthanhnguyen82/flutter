import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class InfusionTimeScreen extends StatefulWidget {
  @override
  _InfusionTimeScreenState createState() => _InfusionTimeScreenState();
}

class _InfusionTimeScreenState extends State<InfusionTimeScreen> {
  TextEditingController _infusionSpeedController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _countdownDurationController = TextEditingController();
  bool _isCountingDown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tốc độ truyền'),
        backgroundColor: const Color.fromARGB(255, 161, 81, 75),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _patientNameController,
                    decoration: InputDecoration(labelText: 'Tên bệnh nhân'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _infusionSpeedController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Tốc độ truyền'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _countdownDurationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Thời gian đồng hồ (giây)'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _handleConfirmation();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: Text('Lưu thông tin', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 16),
                  _isCountingDown
                      ? CountdownTimer(
                          endTime: DateTime.now().millisecondsSinceEpoch +
                              int.parse(_countdownDurationController.text) * 1000,
                          textStyle: TextStyle(fontSize: 24, color: Colors.red),
                          onEnd: () {
                            setState(() {
                              _isCountingDown = false;
                            });
                            // Handle countdown timer end
                            print('Countdown timer ended');
                          },
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isCountingDown = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(primary: Colors.green),
                          child: Text('Bắt đầu', style: TextStyle(color: Colors.white)),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectInfusionSpeed(BuildContext context) async {
    String? pickedSpeed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nhập tốc độ truyền'),
          content: TextField(
            controller: _infusionSpeedController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Tốc độ truyền'),
          ),
        );
      },
    );

    if (pickedSpeed != null && pickedSpeed.isNotEmpty) {
      setState(() {
        _infusionSpeedController.text = pickedSpeed;
      });
    }
  }

  void _handleConfirmation() {
    if (_patientNameController.text.isNotEmpty &&
        _infusionSpeedController.text.isNotEmpty &&
        _countdownDurationController.text.isNotEmpty) {
      print('Tên bệnh nhân: ${_patientNameController.text}');
      print('Đã chọn tốc độ truyền: ${_infusionSpeedController.text} gout/phút');
      print('Thời gian đồng hồ: ${_countdownDurationController.text} giây');

      // Save to Firebase
      _saveInfusionSpeedToFirebase(
        _patientNameController.text,
        _infusionSpeedController.text,
      );
    } else {
      print('Chưa nhập đủ thông tin');
    }
  }

  void _saveInfusionSpeedToFirebase(String patientName, String speed) async {
    try {
      CollectionReference infusionSpeeds =
          FirebaseFirestore.instance.collection('infusion_speeds');

      await infusionSpeeds.add({
        'patient_name': patientName,
        'speed': speed,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Infusion speed added to Firebase");
    } catch (e) {
      print("Failed to add infusion speed: $e");
    }
  }

  @override
  void dispose() {
    _infusionSpeedController.dispose();
    _patientNameController.dispose();
    _countdownDurationController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfusionTimeScreen extends StatefulWidget {
  @override
  _InfusionTimeScreenState createState() => _InfusionTimeScreenState();
}

class _InfusionTimeScreenState extends State<InfusionTimeScreen> {
  TextEditingController _infusionSpeedController = TextEditingController();

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
            SizedBox(height: 16), // Add some spacing
            Container(
              padding: EdgeInsets.all(16), // Add padding around the container
              child: Column(
                children: [
                  TextField(
                    controller: _infusionSpeedController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Tốc độ truyền'),
                  ),
                  SizedBox(height: 16), // Add some spacing
                  ElevatedButton(
                    onPressed: () {
                      _handleConfirmation();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: Text('Lưu thông tin', style: TextStyle(color: Colors.white)),
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
    if (_infusionSpeedController.text.isNotEmpty) {
      print('Đã chọn tốc độ truyền: ${_infusionSpeedController.text} gout/phút');

      // Save to Firebase
      _saveInfusionSpeedToFirebase(_infusionSpeedController.text);
    } else {
      print('Chưa nhập tốc độ truyền');
    }
  }

  void _saveInfusionSpeedToFirebase(String speed) async {
    try {
      // Replace 'infusion_speeds' with the actual name of your Firestore collection
      CollectionReference infusionSpeeds =
          FirebaseFirestore.instance.collection('infusion_speeds');

      // Add a new document with a unique ID
      await infusionSpeeds.add({
        'speed': speed,
        'timestamp': FieldValue.serverTimestamp(), // Optional: Add a timestamp
      });

      print("Infusion speed added to Firebase");
    } catch (e) {
      print("Failed to add infusion speed: $e");
    }
  }

  @override
  void dispose() {
    _infusionSpeedController.dispose();
    super.dispose();
  }
}

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _infusionSpeedController.text.isEmpty
                  ? 'Chưa nhập tốc độ truyền'
                  : 'Tốc độ truyền: ${_infusionSpeedController.text} gout/phút',
            ),
            ElevatedButton(
              onPressed: () {
                _selectInfusionSpeed(context);
              },
              child: Text('Nhập tốc độ truyền'),
            ),
            ElevatedButton(
              onPressed: () {
                _handleConfirmation();
              },
              child: Text('Lưu'),
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
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_infusionSpeedController.text);
              },
              child: Text('Xác nhận'),
            ),
          ],
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
      // Replace 'your_collection' with the actual name of your Firebase collection
      CollectionReference infusionSpeeds =
          FirebaseFirestore.instance.collection('your_collection');

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

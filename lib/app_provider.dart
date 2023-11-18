// lib/app_provider.dart
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String patientName = '';
  String truyenDich = '';
  
  void updatePatientInfo(String name, String infusionType) {
    patientName = name;
    truyenDich = infusionType;
    notifyListeners();
  }
}

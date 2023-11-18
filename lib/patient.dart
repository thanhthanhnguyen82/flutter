// patient.dart

class Patient {
  String name;
  String infusionType;
  String tocdotruyen;
  String dungtichbinh;

  Patient(this.name, this.infusionType, this.tocdotruyen, this.dungtichbinh);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'infusionType': infusionType,
      'tocdotruyen': tocdotruyen,
      'dungtichbinh': dungtichbinh,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      map['name'],
      map['infusionType'],
      map['tocdotruyen'],
      map['dungtichbinh'],
    );
  }
}

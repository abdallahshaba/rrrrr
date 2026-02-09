class MedicationModel {
  final int? id;
  final int userId;
  final String name;
  final String? dosage;
  final String frequency;
  final List<String> times;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? notes;

  MedicationModel({
    this.id,
    required this.userId,
    required this.name,
    this.dosage,
    required this.frequency,
    required this.times,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'times': times.join(','),
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'notes': notes,
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      times: (map['times'] as String).split(','),
      startDate: DateTime.parse(map['start_date']),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      isActive: map['is_active'] == 1,
      notes: map['notes'],
    );
  }
}
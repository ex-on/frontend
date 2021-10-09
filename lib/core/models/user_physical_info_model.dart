//User physical information model
class UserPhysicalInfoModel {
  final DateTime birthDate;
  final int gender;
  final double height;
  final double weight;
  final double bodyFatPercentage;
  final double muscleMass;

  UserPhysicalInfoModel({
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.bodyFatPercentage,
    required this.muscleMass,
  });
}

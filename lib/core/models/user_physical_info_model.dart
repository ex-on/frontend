//User physical information model
class UserPhysicalInfoModel {
  final DateTime birthDate;
  final int gender;
  final double height;
  final double weight;
  final double body_fat_percentage;
  final double muscle_mass;

  UserPhysicalInfoModel({
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.body_fat_percentage,
    required this.muscle_mass,
  });
}

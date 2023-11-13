class UserModel {
  String name;
  String job;

  UserModel({required this.name, required this.job});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(
        name: json['name'],
        job: json['job'],
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'job': job,
  };
}

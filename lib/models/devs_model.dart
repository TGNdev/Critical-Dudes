import 'dart:convert';

DevsData devsDataFromJson(String str) => DevsData.fromJson(json.decode(str));

class DevsData {
  DevsData({
    required this.results,
  });

  List<Devs> results;

  factory DevsData.fromJson(Map<String, dynamic> json) => DevsData(
        results: List<Devs>.from(json['results'].map((x) => Devs.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Devs {
  Devs({
    required this.id,
    required this.name,
    required this.backgroundImage,
  });

  int id;
  String name;
  String backgroundImage;

  factory Devs.fromJson(Map<String, dynamic> json) => Devs(
      id: json['id'],
      name: json['name'],
      backgroundImage: json['image_background'],
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "backgroundImage": backgroundImage,
      };
}

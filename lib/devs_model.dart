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
    required this.gamesCount,
    required this.backgroundImage,
    //required this.platform,
  });

  int id;
  String name;
  int gamesCount;
  String backgroundImage;
  //Platform platform;

  factory Devs.fromJson(Map<String, dynamic> json) => Devs(
      id: json['id'],
      name: json['name'],
      gamesCount: json['games_count'],
      backgroundImage: json['image_background']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "gamesCount": gamesCount,
    "backgroundImage": backgroundImage,
  };
}
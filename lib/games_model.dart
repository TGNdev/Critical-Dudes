import 'dart:convert';

GamesData gamesDataFromJson(String str) => GamesData.fromJson(json.decode(str));

class GamesData {
  GamesData({
    required this.results,
  });

  List<Games> results;

  factory GamesData.fromJson(Map<String, dynamic> json) => GamesData(
    results: List<Games>.from(json['results'].map((x) => Games.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Games {
  Games({
    required this.id,
    required this.name,
    required this.released,
    required this.backgroundImage,
    //required this.platform,
  });

  int id;
  String name;
  String released;
  String backgroundImage;
  //Platform platform;

  factory Games.fromJson(Map<String, dynamic> json) => Games(
    id: json['id'],
    name: json['name'],
    released: json['released'],
    backgroundImage: json['background_image']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "released": released,
    "backgroundImage": backgroundImage,
  };
}

import 'dart:convert';

GamesData gamesDataFromJson(String str) => GamesData.fromJson(json.decode(str));

class GamesData {
  GamesData({
    required this.results,
  });

  List<Games> results;

  factory GamesData.fromJson(Map<String, dynamic> json) => GamesData(
        results:
            List<Games>.from(json['results'].map((x) => Games.fromJson(x))),
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
    required this.platforms,
  });

  int id;
  String name;
  String released;
  String backgroundImage;
  List<dynamic> platforms;

  factory Games.fromJson(Map<String, dynamic> json) => Games(
      id: json['id'],
      name: json['name'],
      released: json['released'],
      backgroundImage: json['background_image'],
      platforms: json['platforms']
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "released": released,
        "backgroundImage": backgroundImage,
        "platforms": platforms
      };
}

class Platforms {
  Platforms({
    required this.platforms
  });

  List<Platform> platforms;

  factory Platforms.fromJson(Map<String, dynamic> json) => Platforms(
    platforms:
    List<Platform>.from(json['platform'].map((x) => Platform.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "platform": List<dynamic>.from(platforms.map((x) => x.toJson())),
  };
}

class Platform {
  Platform({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Platform.fromJson(Map<String, dynamic> json) => Platform(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

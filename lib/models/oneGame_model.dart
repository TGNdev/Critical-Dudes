import 'dart:convert';

OneGameData oneGameDataFromJson(String str) =>
    OneGameData.fromJson(json.decode(str));

class OneGameData {
  OneGameData({
    required this.results,
  });

  List<OneGame> results;

  factory OneGameData.fromJson(Map<String, dynamic> json) => OneGameData(
        results:
            List<OneGame>.from(json['results'].map((x) => OneGame.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class OneGame {
  OneGame(
      {required this.id,
      required this.name,
      required this.released,
      required this.backgroundImage,
      required this.website,
      required this.redditUrl,
      required this.platform,
      required this.developer,
      required this.genre,
      required this.descriptionRaw});

  int id;
  String name;
  String released;
  String backgroundImage;
  String website;
  String redditUrl;
  Platform platform;
  Developer developer;
  Genre genre;
  String descriptionRaw;

  factory OneGame.fromJson(Map<String, dynamic> json) => OneGame(
      id: json['id'],
      name: json['name'],
      released: json['released'],
      backgroundImage: json['background_image'],
      website: json['website'],
      redditUrl: json['reddit_url'],
      descriptionRaw: json['description_raw'],
      platform: Platform.fromJson(json['platforms']['platform']),
      developer: Developer.fromJson(json['developers']),
      genre: Genre.fromJson(json['genres']));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "released": released,
        "backgroundImage": backgroundImage,
        "website": website,
        "reddit_url": redditUrl,
        "descriptionRaw": descriptionRaw,
        "platform": platform,
        "developer": developer,
        "genre": genre
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

class Developer {
  Developer({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Developer.fromJson(Map<String, dynamic> json) => Developer(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

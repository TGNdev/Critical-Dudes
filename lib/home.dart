import 'package:critical_dudes/games_model.dart';
import 'package:critical_dudes/devs_model.dart';
import 'package:critical_dudes/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'configs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Games> games = [];
  static List<Devs> devs = [];

  RefreshController gamesController = RefreshController(initialRefresh: true);
  RefreshController devsController = RefreshController(initialRefresh: true);

  int page = 1;

  Future<bool> getGames({bool isRefresh = false}) async {
    final response = await http.get(Uri.parse(
        "https://api.rawg.io/api/games?key=$apiKey&page_size=$selectedGamesPerList&page=$page"));

    if (response.statusCode == 200) {
      final result = gamesDataFromJson(response.body);

      if (isRefresh == true) {
        games = result.results;
      } else {
        games.addAll(result.results);
      }
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getDevs({bool isRefresh = false}) async {
    final response = await http.get(Uri.parse(
        "https://api.rawg.io/api/developers?key=$apiKey&page_size=$selectedDevsPerList&page=$page"));

    if (response.statusCode == 200) {
      final result = devsDataFromJson(response.body);

      if (isRefresh == true) {
        devs = result.results;
      } else {
        devs.addAll(result.results);
      }
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  Widget _buildGamesList() {
    return SmartRefresher(
      controller: gamesController,
      enablePullUp: true,
      onRefresh: () async {
        page = 1;
        final result = await getGames(isRefresh: true);
        if (result) {
          gamesController.refreshCompleted();
        } else {
          gamesController.refreshFailed();
        }
      },
      onLoading: () async {
        page++;
        final result = await getGames(isRefresh: false);
        if (result) {
          gamesController.loadComplete();
        } else {
          gamesController.loadFailed();
        }
        LoadStyle.ShowWhenLoading;
      },
      child: GridView.builder(
        itemCount: games.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8.0 / 10.0, crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          final game = games[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      game.backgroundImage,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                            child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              minHeight: 8,
                            ),
                            const Text("Loading image..."),
                          ],
                        ));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        game.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDevsList() {
    return SmartRefresher(
      controller: devsController,
      enablePullUp: true,
      onRefresh: () async {
        page = 1;
        final result = await getDevs(isRefresh: true);
        if (result) {
          devsController.refreshCompleted();
        } else {
          devsController.refreshFailed();
        }
      },
      onLoading: () async {
        page++;
        final result = await getDevs(isRefresh: false);
        if (result) {
          devsController.loadComplete();
        } else {
          devsController.loadFailed();
        }
        LoadStyle.ShowWhenLoading;
      },
      child: GridView.builder(
        itemCount: devs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8.0 / 10.0, crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          final dev = devs[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      dev.backgroundImage,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                            child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              minHeight: 8,
                            ),
                            const Text("Loading image..."),
                          ],
                        ));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        dev.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyDrawer(),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverAppBar(
              floating: true,
              title: Text("Games List"),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(text: "Games"),
                  Tab(text: "Developers"),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [_buildGamesList(), _buildDevsList()],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }
}

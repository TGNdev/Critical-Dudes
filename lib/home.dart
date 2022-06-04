import 'package:critical_dudes/games_model.dart';
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
  int page = 1;
  RefreshController controller = RefreshController(initialRefresh: true);

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

  Widget _buildList() {
    return SmartRefresher(
      controller: controller,
      enablePullUp: true,
      onRefresh: () async {
        page = 1;
        final result = await getGames(isRefresh: true);
        if (result) {
          controller.refreshCompleted();
        } else {
          controller.refreshFailed();
        }
      },
      onLoading: () async {
        page++;
        final result = await getGames(isRefresh: false);
        if (result) {
          controller.loadComplete();
        } else {
          controller.loadFailed();
        }
        LoadStyle.ShowWhenLoading;
      },
      child: GridView.builder(
        itemCount: games.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8.0 / 10.0,
            crossAxisCount: 2
        ),
        itemBuilder: (BuildContext context, int index) {
          final game = games[index];
          return Padding(
            padding: const EdgeInsets.all(5),
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
                                const Text("Loading image..."),
                                LinearProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                  minHeight: 8,
                                ),
                              ],
                            )
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(game.name, textAlign: TextAlign.center,),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      /*child: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, int index) {
          final game = games[index];
          return Card(
            child: Column(
              children: [
                Image.network(
                  game.backgroundImage,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: Column(
                        children: [
                          const Text("Loading image..."),
                          LinearProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            minHeight: 8,
                          ),
                        ],
                      )
                    );
                  },
                ),
                ListTile(
                  title: Text(game.name),
                  subtitle: Text('Released on ${game.released}'),
                )
              ],
            ),
          );
        },
      ),*/
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const SliverAppBar(
            floating: true,
            title: Text("Games List"),
            centerTitle: true,
          ),
        ],
        body: _buildList(),
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

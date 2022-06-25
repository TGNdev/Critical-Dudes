import 'dart:typed_data';
import 'dart:ui';

import 'package:critical_dudes/config/configs.dart';
import 'package:critical_dudes/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/games_model.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  static List<Games> games = [];
  RefreshController gamesController = RefreshController(initialRefresh: true);
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

  Widget _buildGamesList(BuildContext context) {
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
            childAspectRatio: 8.0 / 10.0, crossAxisCount: 1),
        itemBuilder: (BuildContext _context, int index) {
          final game = games[index];
          final keyImage = GlobalKey();
          return Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
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
                      child: Flow(
                        delegate: ParallaxFlowDelegate(
                          scrollable: Scrollable.of(context)!,
                          itemContext: context,
                          keyImage: keyImage,),
                        children: [
                          Image.network(
                            game.backgroundImage,
                            fit: BoxFit.cover,
                            key: keyImage,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("Loading image..."),
                                      ),
                                      LinearProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                            : null,
                                        minHeight: 8,
                                      ),
                                    ],
                                  ));
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          game.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Games"),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: _buildGamesList(context),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext itemContext;
  final GlobalKey keyImage;

  ParallaxFlowDelegate({
    required this.scrollable,
    required this.itemContext,
    required this.keyImage
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) =>
      BoxConstraints.tightFor(
        width: constraints.maxWidth,
      );

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final itemBox = itemContext.findRenderObject() as RenderBox;
    final itemOffset = itemBox.localToGlobal(
      itemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction = (itemOffset.dy / viewportDimension).clamp(0, 1);

    final verticalAlignment = Alignment(0, scrollFraction * 2 - 1);

    final imageBox = keyImage.currentContext!.findRenderObject() as RenderBox;
    final childRect = verticalAlignment.inscribe(
      imageBox.size,
      Offset.zero & context.size
    );

    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(0, childRect.top),
      ).transform
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) =>
    scrollable != oldDelegate.scrollable ||
    itemContext != oldDelegate.itemContext ||
    keyImage != oldDelegate.keyImage;
}
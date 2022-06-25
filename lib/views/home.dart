import 'package:critical_dudes/models/games_model.dart';
import 'package:critical_dudes/models/devs_model.dart';
import 'package:critical_dudes/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../config/configs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Devs> devs = [];

  RefreshController devsController = RefreshController(initialRefresh: true);

  int page = 1;

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
                      child: Image.network(
                        dev.backgroundImage,
                        fit: BoxFit.cover,
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          dev.name,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverAppBar(
              floating: true,
              title: Text("Lists"),
              centerTitle: true,
            ),
          ],
          body: const Center(
            child: Text("Welcome to Critical Dudes !"),
          ),
        ),
      );
  }
}

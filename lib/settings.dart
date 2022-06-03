library vars;
import 'package:critical_dudes/configs.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

int selectedGamesPerList = 10;

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: isDark ? Icon(Icons.sunny) : Icon(Icons.dark_mode),
              title: isDark ? Text("Switch to Light Mode") : Text("Switch to Dark Mode"),
              subtitle: Text("Tap to Switch"),
              onTap: () {
                setState((){
                  isDark = !isDark;
                  currentTheme.switchTheme();
                });
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.numbers),
              title: Text("Number of games"),
              subtitle: Text("Choose the amount of games you want to see in the list"),
              trailing: DropdownButton(
                icon: Icon(Icons.arrow_downward),
                items: [
                  DropdownMenuItem(
                    child: Text("6"),
                    value: 6,
                  ),
                  DropdownMenuItem(
                    child: Text("10"),
                    value: 10,
                  ),
                  DropdownMenuItem(
                    child: Text("20"),
                    value: 20,
                  ),
                ],
                onChanged: (int? value) {
                  setState(() {
                    selectedGamesPerList = value!;
                  });
                },
                value: selectedGamesPerList,
              ),
            ),
          )
        ],
      ),
    );
  }
  
}


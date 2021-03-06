library vars;

import 'package:critical_dudes/config/configs.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

int selectedGamesPerList = 10;
int selectedDevsPerList = 10;
bool isDark = true;

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: ListView(
        children: [
          ListTile(
            leading:
                isDark ? const Icon(Icons.sunny) : const Icon(Icons.dark_mode),
            title: isDark
                ? const Text("Switch to Light Mode")
                : const Text("Switch to Dark Mode"),
            subtitle: const Text("Tap to Switch"),
            onTap: () {
              setState(() {
                isDark = !isDark;
                currentTheme.switchTheme();
              });
            },
          ),
          const Divider(thickness: 3),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: const Text("Number of games"),
            subtitle: const Text(
                "Choose the amount of games you want to see in the list"),
            trailing: DropdownButton(
              icon: const Icon(Icons.arrow_downward),
              items: const [
                DropdownMenuItem(
                  value: 6,
                  child: Text("6"),
                ),
                DropdownMenuItem(
                  value: 10,
                  child: Text("10"),
                ),
                DropdownMenuItem(
                  value: 20,
                  child: Text("20"),
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
          const Divider(thickness: 3),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: const Text("Number of developers"),
            subtitle: const Text(
                "Choose the amount of developers you want to see in the list"),
            trailing: DropdownButton(
              icon: const Icon(Icons.arrow_downward),
              items: const [
                DropdownMenuItem(
                  value: 6,
                  child: Text("6"),
                ),
                DropdownMenuItem(
                  value: 10,
                  child: Text("10"),
                ),
                DropdownMenuItem(
                  value: 20,
                  child: Text("20"),
                ),
              ],
              onChanged: (int? value) {
                setState(() {
                  selectedDevsPerList = value!;
                });
              },
              value: selectedDevsPerList,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scribbles/screens/main_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),

      body: ListView(
        children: [
          ListTile(
            title: const Text('Appearance'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaletteWidget()),
              );
            },
          ),
          ListTile(
            title: const Text('about'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PaletteWidget extends StatelessWidget {
  const PaletteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: const Center(child: Text('Appearance')),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About')),
    );
  }
}

class DividerExampleApp extends StatelessWidget {
  const DividerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Divider Example')),
        body: ListView(
          children: const [
            ListTile(title: Text('Item 1')),
            Divider(),
            ListTile(title: Text('Item 2')),
            Divider(),
            ListTile(title: Text('Item 3')),
          ],
        ),
      ),
    );
  }
}

class DividerExample extends StatelessWidget {
  const DividerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: .all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(child: Card(child: SizedBox.expand())),
            Divider(),
            Expanded(child: Card(child: SizedBox.expand())),
          ],
        ),
      ),
    );
  }
}

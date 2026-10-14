import 'package:flutter/material.dart';
import 'package:scribbles/widgets/palette_widget.dart';
import 'package:scribbles/objects/palette.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Scribbles Settings', style: TextStyle(fontSize: 24)),
            ),

            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Appearance'),
              onTap: () {
                // Close the drawer first.
                Navigator.pop(context);

                // Open Appearance.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppearanceScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Image.asset('assets/Scribbles_Logo.png', width: 200, height: 200),
          const SizedBox(height: 24),
          const Expanded(
            child: Center(child: Text('Open the left menu to view settings.')),
          ),
        ],
      ),
    );
  }
}

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Color Palette', style: TextStyle(fontSize: 18)),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Make your own style!'),
                    subtitle: Text(
                      'These are the colors available for customization.',
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  PaletteWidget(
                    0,
                    palette: ColorPalette(key: 'Scribbles'),
                    callback: (int index) {
                      // Handle color selection if needed
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Column(
        children: [
          OutlinedButton(
            onPressed: () {
              // Handle privacy policy button press
            },
            child: const Text('Privacy Policy'),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: const Color.fromARGB(255, 77, 63, 63),
              child: const Center(child: Text('Scribbles DEMO VERSION.')),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Powered by Flutter', style: TextStyle(fontSize: 16)),
            SizedBox(width: 48), // Placeholder for alignment
          ],
        ),
      ),
    );
  }
}

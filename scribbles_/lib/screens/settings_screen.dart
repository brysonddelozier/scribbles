import 'package:flutter/material.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Scribbles_Logo.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: const SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(child: Text('Open the left menu to view settings.')),
        ),
      ),
    );
  }
}

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  static const List<_PaletteOption> _palettes = [
    _PaletteOption('Sunset', Color(0xFFFF6F61)),
    _PaletteOption('Ocean', Color(0xFF3F51B5)),
    _PaletteOption('Forest', Color(0xFF2E7D32)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a color palette:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _palettes.length,
                itemBuilder: (context, index) {
                  final palette = _palettes[index];
                  return ListTile(
                    title: Text(palette.name),
                    leading: CircleAvatar(
                      backgroundColor: palette.primaryColor,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected ${palette.name}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteOption {
  const _PaletteOption(this.name, this.primaryColor);

  final String name;
  final Color primaryColor;
}

class PaletteScreen extends StatelessWidget {
  const PaletteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Palette')),
      body: const Center(child: Text('This is the Palette screen.')),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('Scribbles DEMO VERSION.')),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Text('Powered by Flutter', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 48), // Placeholder for alignment
          ],
        ),
      ),
    );
  }
}

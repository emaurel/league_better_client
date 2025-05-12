import 'package:flutter/material.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/api/extensions/championService.dart';
import 'package:league_better_client/models/Champion.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Champion> champions = [];
  Champion? selectedChampion;

  Future<void> fetchChampions() async {
    final tempChampions = await BetterClientApi.instance.getAllChampions(
      BetterClientApi.instance.summonerId!,
    );
    for (var champ in tempChampions) {
      await champ.loadImages();
    }
    tempChampions.removeAt(0); // remove placeholder
    tempChampions.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      champions = tempChampions;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchChampions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedChampion == null ? 0 : 1,
        children: [
          _buildChampionList(),
          if (selectedChampion != null)
            ChampionPage(
              champion: selectedChampion!,
              onBack: () {
                setState(() {
                  selectedChampion = null;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildChampionList() {
    return Center(
      child:
          champions.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: champions.length,
                  itemBuilder: (context, index) {
                    final champion = champions[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedChampion = champion;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: champion.baseLoadScreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            champion.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
              : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Fetching champions...'),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
    );
  }
}

class ChampionPage extends StatelessWidget {
  final Champion champion;
  final VoidCallback onBack;

  const ChampionPage({super.key, required this.champion, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Splash
        Positioned.fill(child: Opacity(opacity: 1, child: champion.baseSplash)),

        // Back Button (top left)
        SafeArea(
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: onBack,
          ),
        ),

        // Left-aligned info + Back to Inventory button
        Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    champion.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    champion.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children:
                        champion.roles
                            .map(
                              (role) => Chip(
                                label: Text(role),
                                backgroundColor: Colors.blue.shade50,
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 16),
                  InfoRow(
                    label: "Difficulty",
                    value: champion.tacticalInfo.difficulty.toString(),
                  ),
                  InfoRow(
                    label: "Style",
                    value: champion.tacticalInfo.style.toString(),
                  ),
                  const SizedBox(height: 24),

                  // ✅ Back to Inventory Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Back"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

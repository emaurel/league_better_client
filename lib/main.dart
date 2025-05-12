import 'package:flutter/material.dart';
import 'package:league_better_client/api/extensions/FriendService.dart';
import 'package:league_better_client/models/Summoner.dart';
import 'package:league_better_client/api/exports.dart';
import 'package:league_better_client/pages/friendPage.dart';
import 'package:league_better_client/pages/inventoryPage.dart';

void main() async {
  await BetterClientApi.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal LoL Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPageIndex = 0;

  // Cache the pages (so they don't rebuild)
  List<Widget> get _pages => [
    _buildHomePage(), // ✅ Always fresh build
    const InventoryPage(),
    const FriendListPage(),
    const Center(
      child: Text('Stats Page (Coming Soon)', style: TextStyle(fontSize: 24)),
    ),
  ];

  Summoner summoner = Summoner(
    accountId: '',
    summonerId: '',
    gameName: '',
    puuid: '',
    tagLine: '',
    profileIconId: '',
    summonerLevel: 0,
  );

  Future<void> fetchSummoner() async {
    await BetterClientApi.instance.getAllFriends();
    final summonerInfo = await BetterClientApi.instance.getSummonerInfo();
    if (summonerInfo != null) {
      final tempSummoner = Summoner.fromJson(summonerInfo);
      await tempSummoner.loadImages();
      setState(() {
        summoner = tempSummoner;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSummoner();

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedPageIndex = _tabController.index;
        });
      }
    });

    
  }

  Widget _buildHomePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Current user:', style: TextStyle(fontSize: 20)),
          summoner.draw(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchSummoner,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimal LoL Client'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.inventory), text: 'Inventory'),
            Tab(icon: Icon(Icons.group), text: 'Friends'),
            Tab(icon: Icon(Icons.assessment), text: 'Stats'),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedPageIndex, children: _pages),
    );
  }
}

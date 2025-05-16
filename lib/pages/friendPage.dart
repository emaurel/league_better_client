import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/api/extensions/FriendService.dart';
import 'package:league_better_client/api/websockets/testWebSocket.dart';
import 'package:league_better_client/events/events.dart';
import 'package:league_better_client/events/friendEvents.dart';
import 'package:league_better_client/models/Friend.dart';
import 'package:league_better_client/models/Queue.dart';
import 'package:league_better_client/models/Summoner.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  List<Friend> friends = [];
  bool isLoading = true;
  LcuWebSocketClient friendListSocketClient = LcuWebSocketClient();

  @override
  void initState() {
    super.initState();
    fetchFriends();
    initFriendSocket();
  }

  void updateOneFriend(Friend friend) {
    setState(() {
      final index = friends.indexWhere((f) => f.id == friend.id);
      if (index != -1) {
        friends[index] = friend;
      }
    });
  }

  @override
  void dispose() {
    friendListSocketClient.disconnect();
    super.dispose();
  }

  Future<void> initFriendSocket() async {
    await friendListSocketClient.connect('OnJsonApiEvent_lol-chat_v1_friends');
    friendListSocketClient.listen((event) async {
      final allEventData = jsonDecode(event);
      final eventData = allEventData[2];
      final data = eventData["data"];
      final eventType = eventData["eventType"];
      print(eventType);
      final friend = Friend.fromJson(data);
      await friend.loadImages();
      await friend.loadGameQueue();
      if (eventType == 'Update') {
        print('Friend updated: ${friend.name}');
        updateOneFriend(friend);
      } else if (eventType == 'Delete') {
        setState(() {
          friends.removeWhere((f) => f.id == friend.id);
        });
      } else if (eventType == 'Create') {
        setState(() {
          friends.add(friend);
        });
      }
      
    });

  }

  Future<void> fetchFriends() async {
    final fetchedFriends =
        await BetterClientApi.instance
            .getAllFriends(); // Fetch your friends list here
    for (var friend in fetchedFriends) {
      await friend.loadImages();
      await friend.loadGameQueue();
    }

    setState(() {
      friends = fetchedFriends;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (friends.isEmpty) {
      return const Center(child: Text('No friends found.'));
    }

    // 🟢 Group friends by groupName
    final Map<String, List<Friend>> grouped = {};
    for (var friend in friends) {
      grouped.putIfAbsent(friend.groupName, () => []).add(friend);
    }

    // 🟢 Sort group names: normal groups first, then those starting with '**'
    final sortedGroupEntries =
        grouped.entries.toList()..sort((a, b) {
          final aStartsWithStars = a.key.startsWith('**');
          final bStartsWithStars = b.key.startsWith('**');
          if (aStartsWithStars && !bStartsWithStars) return 1;
          if (!aStartsWithStars && bStartsWithStars) return -1;
          return a.key.compareTo(b.key); // Alphabetical among same type
        });

    // sort friend in each group by availability, chat first
    for (var entry in sortedGroupEntries) {
      entry.value.sort((a, b) {
        // Define custom order for availability
        const availabilityOrder = {
          'inGame': 2,
          'championSelect': 2,
          'chat': 1,
          'away': 3,
          'dnd': 4,
          'offline': 5,
        };

        if (!availabilityOrder.containsKey(a.availability) ||
            !availabilityOrder.containsKey(b.availability)) {
          return 0; // If availability is not in the order, keep original order
        }

        // Compare availability first
        int availabilityComparison = availabilityOrder[a.availability]!
            .compareTo(availabilityOrder[b.availability]!);
        if (availabilityComparison != 0) return availabilityComparison;

        // If availability is the same, compare by gameName alphabetically
        return a.gameName.compareTo(b.gameName);
      });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            sortedGroupEntries.map((entry) {
              final onlineFriendsCount =
                  entry.value
                      .where((friend) => friend.availability != 'offline')
                      .length;
              final friendsCount = entry.value.length;
              String groupName =
                  """${entry.key.isEmpty ? 'Ungrouped' : entry.key} ($onlineFriendsCount/$friendsCount)""";

              // 🟢 Remove '**' for display
              if (groupName.startsWith('**')) {
                groupName = groupName.replaceFirst('**', '');
              }

              final groupFriends = entry.value;

              return Container(
                width: 200,
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        groupName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height *
                          0.7, // Make it scroll vertically
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupFriends.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: groupFriends[index].draw(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}

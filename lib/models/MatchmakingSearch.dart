import 'package:league_better_client/models/DodgeData.dart';
import 'package:league_better_client/models/LowPriorityData.dart';
import 'package:league_better_client/models/MatchmakingSearchError.dart';
import 'package:league_better_client/models/ReadyCheck.dart';

enum MatchmakingSearchState {
  searching,
  found,
  invalid,
  error;

  String get name {
    switch (this) {
      case MatchmakingSearchState.searching:
        return 'Searching';
      case MatchmakingSearchState.found:
        return 'Found';
      case MatchmakingSearchState.error:
        return 'Error';
      case MatchmakingSearchState.invalid:
        return 'Invalid';
    }
  }

  MatchmakingSearchState fromString(String state) {
    switch (state) {
      case 'Searching':
        return MatchmakingSearchState.searching;
      case 'Found':
        return MatchmakingSearchState.found;
      case 'Error':
        return MatchmakingSearchState.error;
      case 'Invalid':
        return MatchmakingSearchState.invalid;
      default:
        throw Exception('Unknown state: $state');
    }
  }
}

class MatchmakingSearch {
  DodgeData? dodgeData;
  List<MatchmakingSearchError>? errors;
  double? estimatedQueueTime;
  bool? isCurrentlyInQueue;
  String? lobbyId;
  LowPriorityData? lowPriorityData;
  int? queueId;
  ReadyCheck? readyCheck;
  MatchmakingSearchState searchState;
  double timeInQueue;

  MatchmakingSearch({
    this.dodgeData,
    this.errors,
    this.estimatedQueueTime,
    this.isCurrentlyInQueue,
    this.lobbyId,
    this.lowPriorityData,
    this.queueId,
    this.readyCheck,
    required this.searchState,
    required this.timeInQueue,
  });

  factory MatchmakingSearch.fromJson(Map<String, dynamic> json) {
    return MatchmakingSearch(
      dodgeData:
          json['dodgeData'] != null
              ? DodgeData.fromJson(json['dodgeData'])
              : null,
      errors:
          json['errors'] != null
              ? (json['errors'] as List)
                  .map((e) => MatchmakingSearchError.fromJson(e))
                  .toList()
              : null,
      estimatedQueueTime: json['estimatedQueueTime']?.toDouble(),
      isCurrentlyInQueue: json['isCurrentlyInQueue'],
      lobbyId: json['lobbyId'],
      lowPriorityData:
          json['lowPriorityData'] != null
              ? LowPriorityData.fromJson(json['lowPriorityData'])
              : null,
      queueId: json['queueId'],
      readyCheck:
          json['readyCheck'] != null
              ? ReadyCheck.fromJson(json['readyCheck'])
              : null,
      searchState: MatchmakingSearchState.values.firstWhere(
        (e) => e.name == json['searchState'],
        orElse: () => MatchmakingSearchState.searching,
      ),
      timeInQueue: json['timeInQueue']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dodgeData': dodgeData?.toJson(),
      'errors': errors?.map((e) => e.toJson()).toList(),
      'estimatedQueueTime': estimatedQueueTime,
      'isCurrentlyInQueue': isCurrentlyInQueue,
      'lobbyId': lobbyId,
      'lowPriorityData': lowPriorityData?.toJson(),
      'queueId': queueId,
      'readyCheck': readyCheck?.toJson(),
      'searchState': searchState.name,
      'timeInQueue': timeInQueue,
    };
  }
}

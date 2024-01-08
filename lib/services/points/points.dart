import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NOMNOM/providers/providers.dart';

import '../../constants/storage_box_constants.dart';

final pointsProvider = Provider<Points>((ref) {
  return Points(ref);
});

class Points {
  Points(this.ref);
  final Ref ref;
  static const int recipePoints = 10;
  static const int challengePoints = 30;
  static const int pointsPerLevel = 20;
  static const String pointsBoxKey = 'totalPoints';

  int getTotalPoints() {
    final storageService = ref.watch(storageServiceProvider);
    final totalPoints =
        storageService.getValue<int>(pointsBoxKey, StorageBox.pointsBox);
    if (totalPoints != null) {
      return totalPoints;
    }
    return 0;
  }

  void addPoints(int points) {
    final storageService = ref.watch(storageServiceProvider);
    final pointsStorage =
        storageService.getValue<int>(pointsBoxKey, StorageBox.pointsBox);
    if (pointsStorage != null) {
      int totalPointsBox = pointsStorage;
      totalPointsBox += points;
      storageService.setValue<int>(
          pointsBoxKey, totalPointsBox, StorageBox.pointsBox);
    } else {
      storageService.setValue<int>(pointsBoxKey, 10, StorageBox.pointsBox);
    }
  }

  int calculateLevel() {
    final storageService = ref.watch(storageServiceProvider);
    final int level;
    final pointsStorage =
        storageService.getValue<int>(pointsBoxKey, StorageBox.pointsBox);
    if (pointsStorage != null) {
      level = ((pointsStorage as int) ~/ pointsPerLevel) + 1;
    } else {
      level = 1;
    }
    return level;
  }
}

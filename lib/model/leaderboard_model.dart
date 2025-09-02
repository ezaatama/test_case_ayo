// models/leaderboard_model.dart
class LeaderboardItem {
  final String id;
  final String name;
  final String? username;
  final int points;
  final int rank;
  final String location;
  final String type;
  final String category;
  final String season;
  final String? imageUrl;
  final String? imageUrl2;
  final bool isUser;
  final List<String>? participants;

  LeaderboardItem({
    required this.id,
    required this.name,
    this.username,
    required this.points,
    required this.rank,
    required this.location,
    required this.type,
    required this.category,
    required this.season,
    this.imageUrl,
    this.imageUrl2,
    this.isUser = false,
    this.participants,
  });
}

class FilterOption {
  final String id;
  final String name;
  final String type;
  final bool isSelected;
  final String? emoji;

  FilterOption({
    required this.id,
    required this.name,
    required this.type,
    this.isSelected = false,
    this.emoji,
  });

  FilterOption copyWith({bool? isSelected}) {
    return FilterOption(
      id: id,
      name: name,
      type: type,
      isSelected: isSelected ?? this.isSelected,
      emoji: emoji,
    );
  }
}

class SportCategory {
  final String id;
  final String name;
  final String emoji;
  final bool isPreferred;

  SportCategory({
    required this.id,
    required this.name,
    required this.emoji,
    this.isPreferred = false,
  });

  SportCategory copyWith({bool? isPreferred}) {
    return SportCategory(
      id: id,
      name: name,
      emoji: emoji,
      isPreferred: isPreferred ?? this.isPreferred,
    );
  }
}

class Region {
  final String id;
  final String name;
  final String code;
  final bool isPopular;

  Region({
    required this.id,
    required this.name,
    required this.code,
    this.isPopular = false,
  });
}

part of 'leaderboard_cubit.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardItem> leaderboard;
  final String currentFilter;
  final String currentCabor;
  final String currentCategory;
  final String selectedLocation;
  final bool isEmptyState;

  LeaderboardLoaded({
    required this.leaderboard,
    required this.currentFilter,
    required this.currentCabor,
    required this.currentCategory,
    required this.selectedLocation,
  }) : isEmptyState = leaderboard.isEmpty;

  LeaderboardLoaded copyWith({
    List<LeaderboardItem>? leaderboard,
    String? currentFilter,
    String? currentCabor,
    String? currentCategory,
    String? selectedLocation,
  }) {
    return LeaderboardLoaded(
      leaderboard: leaderboard ?? this.leaderboard,
      currentFilter: currentFilter ?? this.currentFilter,
      currentCabor: currentCabor ?? this.currentCabor,
      currentCategory: currentCategory ?? this.currentCategory,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}

// class LeaderboardLoaded extends LeaderboardState {
//   final List<LeaderboardItem> leaderboard;
//   final String currentCabor;
//   final String currentCategory;
//   final String currentFilter;
//   final String? selectedSport;
//   final String? selectedRegion;
//   final String selectedTipe;
//   final bool isEmptyState;
//   final String selectedLocation;

//   const LeaderboardLoaded({
//     required this.leaderboard,
//     required this.currentCabor,
//     required this.currentCategory,
//     required this.currentFilter,
//     this.selectedSport,
//     this.selectedRegion,
//     required this.selectedTipe,
//     required this.isEmptyState,
//     required this.selectedLocation,
//   });

//   @override
//   List<Object> get props => [
//     leaderboard,
//     currentCabor,
//     currentCategory,
//     currentFilter,
//     selectedSport ?? '',
//     selectedRegion ?? '',
//     selectedTipe,
//     isEmptyState,
//     selectedLocation, // Tambahkan ini
//   ];

//   LeaderboardLoaded copyWith({
//     List<LeaderboardItem>? leaderboard,
//     String? currentCategory,
//     String? currentFilter,
//     String? selectedSport,
//     String? selectedRegion,
//     String? selectedTipe,
//     bool? isEmptyState,
//     String? selectedLocation,
//     String? currentCabor,
//   }) {
//     return LeaderboardLoaded(
//       leaderboard: leaderboard ?? this.leaderboard,
//       currentCategory: currentCategory ?? this.currentCategory,
//       currentFilter: currentFilter ?? this.currentFilter,
//       selectedSport: selectedSport ?? this.selectedSport,
//       selectedRegion: selectedRegion ?? this.selectedRegion,
//       selectedTipe: selectedTipe ?? this.selectedTipe,
//       isEmptyState: isEmptyState ?? this.isEmptyState,
//       selectedLocation: selectedLocation ?? this.selectedLocation,
//       currentCabor: currentCabor ?? this.currentCabor,
//     );
//   }
// }

class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError(this.message);

  @override
  List<Object> get props => [message];
}

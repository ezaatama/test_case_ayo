import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:test_case_ayo/model/data_dummy.dart';
import 'package:test_case_ayo/model/leaderboard_model.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit() : super(LeaderboardInitial());

  String currentFilter = 'All Time';
  String currentCabor = 'Badminton';
  String currentCategory = 'Tunggal';
  String selectedLocation = 'Surabaya';

  void loadInitialData() {
    emit(LeaderboardLoading());
    try {
      List<LeaderboardItem> sourceData;

      if (currentCategory.toLowerCase() == 'tunggal') {
        sourceData = DummyData.tunggalLeaderboard;
      } else if (currentCategory.toLowerCase() == 'ganda') {
        sourceData = DummyData.gandaLeaderboard;
      } else if (currentCategory.toLowerCase() == 'komunitas') {
        sourceData = DummyData.komunitasLeaderboard;
      } else if (currentCategory.toLowerCase() == 'participated') {
        sourceData = DummyData.participatedLeaderboard;
      } else {
        sourceData = DummyData.tunggalLeaderboard;
      }

      // Filter data berdasarkan kriteria
      final filteredData = _filterData(
        sourceData,
        currentCabor,
        currentCategory,
        selectedLocation,
      );

      emit(
        LeaderboardLoaded(
          leaderboard: filteredData,
          currentFilter: currentFilter,
          currentCabor: currentCabor,
          currentCategory: currentCategory,
          selectedLocation: selectedLocation,
        ),
      );
    } catch (e) {
      emit(LeaderboardError('Failed to load data: $e'));
    }
  }

  void changeFilter(String type, String value) {
    if (type == 'periode') {
      currentFilter = value;
    }
    loadInitialData();
  }

  void changeCabor(String value) {
    currentCabor = value;
    loadInitialData();
  }

  void changeCategory(String value) {
    currentCategory = value;
    loadInitialData();
  }

  void changeLocation(String value) {
    selectedLocation = value;
    loadInitialData();
  }

  // Fungsi untuk memfilter data berdasarkan kriteria
  List<LeaderboardItem> _filterData(
    List<LeaderboardItem> data,
    String cabor,
    String category,
    String location,
  ) {
    final filtered = data.where((item) {
      bool matchesCabor = item.category.toLowerCase() == cabor.toLowerCase();
      bool matchesCategory = item.type.toLowerCase() == category.toLowerCase();
      bool matchesLocation =
          item.location.toLowerCase() == location.toLowerCase();

      return matchesCabor && matchesCategory && matchesLocation;
    }).toList();

    return filtered;
  }

  // void loadInitialData() {
  //   emit(LeaderboardLoading());

  //   try {
  //     // Simulate API delay
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       final leaderboard = DummyData.tunggalLeaderboard;
  //       emit(
  //         LeaderboardLoaded(
  //           leaderboard: leaderboard,
  //           currentCategory: 'Tunggal',
  //           currentFilter: 'All Time',
  //           selectedTipe: 'Overall',
  //           isEmptyState: leaderboard.isEmpty,
  //           selectedLocation: 'Surabaya', // Default location
  //           currentCabor: 'Tenis Meja',
  //         ),
  //       );
  //     });
  //   } catch (e) {
  //     emit(LeaderboardError('Failed to load data: $e'));
  //   }
  // }

  // void changeCategory(String category) {
  //   final currentState = state;
  //   if (currentState is! LeaderboardLoaded) return;

  //   try {
  //     List<LeaderboardItem> newLeaderboard;

  //     switch (category) {
  //       case 'Komunitas':
  //         newLeaderboard = DummyData.komunitasLeaderboard;
  //         break;
  //       case 'Tunggal':
  //         newLeaderboard = DummyData.tunggalLeaderboard;
  //         break;
  //       case 'Ganda':
  //         newLeaderboard = DummyData.gandaLeaderboard;
  //         break;
  //       case 'Participated':
  //         newLeaderboard = DummyData.participatedLeaderboard;
  //         break;
  //       default:
  //         newLeaderboard = [];
  //     }

  //     // Apply current filters
  //     newLeaderboard = _applyFilters(
  //       newLeaderboard,
  //       currentState.selectedSport,
  //       currentState.selectedLocation,
  //       currentState.currentCabor,
  //     );

  //     newLeaderboard.sort((a, b) => a.rank.compareTo(b.rank));

  //     emit(
  //       currentState.copyWith(
  //         leaderboard: newLeaderboard,
  //         currentCategory: category,
  //         isEmptyState: newLeaderboard.isEmpty,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(LeaderboardError('Failed to change category: $e'));
  //   }
  // }

  // void changeLocation(String location) {
  //   final currentState = state;
  //   if (currentState is! LeaderboardLoaded) return;

  //   try {
  //     List<LeaderboardItem> filteredLeaderboard = _applyFilters(
  //       _getLeaderboardByCategory(currentState.currentCategory),
  //       currentState.selectedSport,
  //       currentState.currentCabor,
  //       location,
  //     );

  //     filteredLeaderboard.sort((a, b) => a.rank.compareTo(b.rank));

  //     emit(
  //       currentState.copyWith(
  //         leaderboard: filteredLeaderboard,
  //         selectedLocation: location,
  //         isEmptyState: filteredLeaderboard.isEmpty,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(LeaderboardError('Failed to change location: $e'));
  //   }
  // }

  // void changeFilter(String filterType, String value) {
  //   final currentState = state;
  //   if (currentState is! LeaderboardLoaded) return;

  //   try {
  //     List<LeaderboardItem> filteredLeaderboard;

  //     switch (filterType) {
  //       case 'periode':
  //         filteredLeaderboard = _applyFilters(
  //           _getLeaderboardByCategory(currentState.currentCategory),
  //           currentState.selectedSport,
  //           currentState.selectedLocation,
  //           currentState.currentCabor,
  //         );

  //         emit(
  //           currentState.copyWith(
  //             leaderboard: filteredLeaderboard,
  //             currentFilter: value,
  //             isEmptyState: filteredLeaderboard.isEmpty,
  //           ),
  //         );
  //         break;

  //       case 'tipe':
  //         filteredLeaderboard = _applyFilters(
  //           _getLeaderboardByCategory(currentState.currentCategory),
  //           currentState.selectedSport,
  //           currentState.selectedLocation,
  //           currentState.currentCabor,
  //         );

  //         emit(
  //           currentState.copyWith(
  //             leaderboard: filteredLeaderboard,
  //             selectedTipe: value,
  //             isEmptyState: filteredLeaderboard.isEmpty,
  //           ),
  //         );
  //         break;
  //     }
  //   } catch (e) {
  //     emit(LeaderboardError('Failed to change filter: $e'));
  //   }
  // }

  // void changeCabor(String cabor) {
  //   final currentState = state;
  //   if (currentState is! LeaderboardLoaded) return;

  //   try {
  //     List<LeaderboardItem> filteredLeaderboard = _applyFilters(
  //       _getLeaderboardByCategory(currentState.currentCategory),
  //       currentState.selectedSport,
  //       currentState.selectedLocation,
  //       cabor, // Gunakan cabor yang baru
  //     );

  //     filteredLeaderboard.sort((a, b) => a.rank.compareTo(b.rank));

  //     emit(
  //       currentState.copyWith(
  //         leaderboard: filteredLeaderboard,
  //         currentCabor: cabor,
  //         isEmptyState: filteredLeaderboard.isEmpty,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(LeaderboardError('Failed to change cabor: $e'));
  //   }
  // }

  // void changeSport(String sport) {
  //   final currentState = state;
  //   if (currentState is! LeaderboardLoaded) return;

  //   try {
  //     List<LeaderboardItem> filteredLeaderboard = _applyFilters(
  //       _getLeaderboardByCategory(currentState.currentCategory),
  //       sport, // Gunakan sport yang baru
  //       currentState.selectedLocation,
  //       currentState.currentCabor,
  //     );

  //     filteredLeaderboard.sort((a, b) => a.rank.compareTo(b.rank));

  //     emit(
  //       currentState.copyWith(
  //         leaderboard: filteredLeaderboard,
  //         selectedSport: sport,
  //         isEmptyState: filteredLeaderboard.isEmpty,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(LeaderboardError('Failed to change sport: $e'));
  //   }
  // }

  // List<LeaderboardItem> _getLeaderboardByCategory(String category) {
  //   switch (category) {
  //     case 'Komunitas':
  //       return DummyData.komunitasLeaderboard;
  //     case 'Tunggal':
  //       return DummyData.tunggalLeaderboard;
  //     case 'Ganda':
  //       return DummyData.gandaLeaderboard;
  //     case 'Participated':
  //       return DummyData.participatedLeaderboard;
  //     default:
  //       return [];
  //   }
  // }

  // List<LeaderboardItem> _applyFilters(
  //   List<LeaderboardItem> data,
  //   String? sport,
  //   String location,
  //   String cabor,
  // ) {
  //   var filteredData = List<LeaderboardItem>.from(data);

  //   // Filter berdasarkan location
  //   filteredData = filteredData
  //       .where((item) => item.location == location)
  //       .toList();

  //   // Filter berdasarkan sport jika dipilih
  //   if (sport != null && sport != 'Semua Olahraga') {
  //     filteredData = filteredData
  //         .where((item) => item.category == sport)
  //         .toList();
  //   }

  //   filteredData = filteredData
  //       .where((item) => item.category == cabor)
  //       .toList();

  //   return filteredData;
  // }
}

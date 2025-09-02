// widgets/leaderboard_card.dart
import 'package:flutter/material.dart';
import 'package:test_case_ayo/model/leaderboard_model.dart';

class LeaderboardCard extends StatelessWidget {
  final LeaderboardItem item;

  const LeaderboardCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildRankIndicator(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        trailing: _buildPoints(),
        tileColor: item.isUser ? Colors.blue.withOpacity(0.1) : null,
      ),
    );
  }

  Widget _buildRankIndicator() {
    // Untuk ranking 1, 2, 3 tampilkan medali
    if (item.rank <= 3) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.emoji_events, size: 40, color: _getMedalColor()),
          Text(
            item.rank.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    // Untuk ranking lainnya tampilkan angka biasa
    return CircleAvatar(
      backgroundColor: _getRankColor(),
      child: Text(
        item.rank.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: item.isUser ? Colors.blue : Colors.black,
          ),
        ),
        if (item.username != null)
          Text(
            item.username!,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.participants != null)
          Text(
            'Participants: ${item.participants!.join(", ")}',
            style: const TextStyle(fontSize: 12),
          ),
        Text(
          '${item.location} • ${item.category}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPoints() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${item.points} Pts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: item.isUser ? Colors.blue : Colors.black,
          ),
        ),
        if (item.isUser)
          Text(
            '#Your Rank',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Color _getMedalColor() {
    switch (item.rank) {
      case 1:
        return Colors.yellow[700]!;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Colors.blue;
    }
  }

  Color _getRankColor() {
    return item.isUser ? Colors.blue : Colors.grey;
  }
}

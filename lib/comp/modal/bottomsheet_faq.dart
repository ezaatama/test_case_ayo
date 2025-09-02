import 'package:flutter/material.dart';
import 'package:test_case_ayo/comp/separator.dart';
import 'package:test_case_ayo/utils/constant.dart';

void showPointRulesModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cara Mendapatkan Point",
                  style: TextStyleUI.SUBTITLE1.copyWith(
                    fontWeight: FontUI.WEIGHT_REGULAR,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Kamu harus menyelesaikan pertandingan untuk dapat mendapatkan point.",
              style: TextStyleUI.BODY2.copyWith(
                fontWeight: FontUI.WEIGHT_LIGHT,
              ),
            ),
            SizedBox(height: 16),

            // Hasil Pertandingan
            Text(
              "Hasil Pertandingan",
              style: TextStyleUI.SUBTITLE1.copyWith(
                fontWeight: FontUI.WEIGHT_REGULAR,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              decoration: BoxDecoration(
                color: ColorUI.WHITE,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: ColorUI.TEXT_INK10),
              ),
              child: Column(
                children: [
                  _buildPointRow("Menang", "+100 Pts", ColorUI.GREEN),
                  MySeparator(),
                  _buildPointRow("Draw", "+50 Pts", ColorUI.GREEN),
                  MySeparator(),
                  _buildPointRow("Kalah", "-50 Pts", ColorUI.RED),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Bonus Point
            Text("Bonus Point", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorUI.WHITE,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: ColorUI.TEXT_INK10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bonus Kemenangan"),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorUI.GREEN_LIGHT,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "n x 5 Pts",
                          style: TextStyleUI.BODY3.copyWith(
                            color: ColorUI.GREEN,
                            fontWeight: FontUI.WEIGHT_REGULAR,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Point (n) didapatkan berdasarkan selisih peringkat dengan lawan di leaderboard. Nilai point maksimum yang dapat ditambahkan adalah 20 Pts",
                    style: TextStyleUI.BODY3.copyWith(
                      fontWeight: FontUI.WEIGHT_LIGHT,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

Widget _buildPointRow(String title, String point, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyleUI.BODY2.copyWith(fontWeight: FontUI.WEIGHT_REGULAR),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            point,
            style: TextStyleUI.BODY3.copyWith(
              color: color,
              fontWeight: FontUI.WEIGHT_REGULAR,
            ),
          ),
        ),
      ],
    ),
  );
}

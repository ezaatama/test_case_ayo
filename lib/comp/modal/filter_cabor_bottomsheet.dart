// widgets/sport_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case_ayo/comp/button/primary_button.dart';
import 'package:test_case_ayo/data/leaderboard_cubit.dart';
import 'package:test_case_ayo/model/data_dummy.dart';
import 'package:test_case_ayo/model/leaderboard_model.dart';

// widgets/filter_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:test_case_ayo/utils/constant.dart';

class FilterCaborBottomSheet extends StatefulWidget {
  final String title;
  final List<SportCategory> options;
  final Function(SportCategory) onSelected;
  final String initialValue;

  const FilterCaborBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
    required this.initialValue,
  });

  @override
  State<FilterCaborBottomSheet> createState() => _FilterCaborBottomSheetState();
}

class _FilterCaborBottomSheetState extends State<FilterCaborBottomSheet> {
  late String _radioSelected;
  late String _selectedName;

  @override
  void initState() {
    super.initState();
    // Set initial value berdasarkan initialValue yang diberikan
    final initialOption = widget.options.firstWhere(
      (opt) => opt.name == widget.initialValue,
      orElse: () => widget.options.first,
    );
    _radioSelected = initialOption.id;
    _selectedName = initialOption.name;
  }

  // Filter options untuk mendapatkan hanya yang isPreferred = true
  List<SportCategory> get preferredOptions {
    return widget.options.where((option) => option.isPreferred).toList();
  }

  // Filter options untuk mendapatkan semua kategori (atau yang tidak preferred)
  List<SportCategory> get allOptions {
    return widget.options.where((option) => !option.isPreferred).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        shrinkWrap: true, // ← PENTING: shrinkWrap true
        physics: const ClampingScrollPhysics(),
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyleUI.SUBTITLE1.copyWith(
                  fontWeight: FontUI.WEIGHT_REGULAR,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Preferensi Section - Hanya menampilkan yang isPreferred = true
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: ColorUI.TEXT_INK0,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Preferensi Olahragamu",
                  style: TextStyleUI.SUBTITLE2.copyWith(
                    fontWeight: FontUI.WEIGHT_REGULAR,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: preferredOptions.length,
                itemBuilder: (context, index) {
                  final option = preferredOptions[index];
                  return _buildPreferensiItem(context, option);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: ColorUI.TEXT_INK0,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Semua Olahraga",
                  style: TextStyleUI.SUBTITLE2.copyWith(
                    fontWeight: FontUI.WEIGHT_REGULAR,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: allOptions.length,
                itemBuilder: (context, index) {
                  final option = allOptions[index];
                  return _buildAllCategorySportItem(context, option);
                },
              ),
            ],
          ),

          // Apply Button
          const SizedBox(height: 16),
          PrimaryButton(
            text: "Terapkan",
            onPressed: () {
              // Cari option yang sesuai dengan _radioSelected
              final selectedOption = widget.options.firstWhere(
                (opt) => opt.id == _radioSelected,
                orElse: () => widget.options.first,
              );

              // Panggil callback dengan option yang dipilih
              widget.onSelected(selectedOption);

              // Tutup bottom sheet
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferensiItem(BuildContext context, SportCategory option) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(option.emoji, width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text(
                      option.name,
                      style: TextStyleUI.BODY2.copyWith(
                        fontWeight: FontUI.WEIGHT_REGULAR,
                      ),
                    ),
                  ],
                ),
              ),
              Radio(
                value: option.id,
                groupValue: _radioSelected,
                activeColor: ColorUI.PRIMARY,
                onChanged: (value) {
                  setState(() {
                    _radioSelected = value!;
                    _selectedName = option.name;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllCategorySportItem(
    BuildContext context,
    SportCategory option,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(option.emoji, width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text(
                      option.name,
                      style: TextStyleUI.BODY2.copyWith(
                        fontWeight: FontUI.WEIGHT_REGULAR,
                      ),
                    ),
                  ],
                ),
              ),
              Radio(
                value: option.id,
                groupValue: _radioSelected,
                activeColor: ColorUI.PRIMARY,
                onChanged: (value) {
                  setState(() {
                    _radioSelected = value!;
                    _selectedName = option.name;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

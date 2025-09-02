// widgets/sport_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:test_case_ayo/comp/button/primary_button.dart';
import 'package:test_case_ayo/comp/separator.dart';
import 'package:test_case_ayo/model/leaderboard_model.dart';

// widgets/filter_bottom_sheet.dart
import 'package:test_case_ayo/utils/constant.dart';

class FilterCategoryBottomSheet extends StatefulWidget {
  final String title;
  final List<FilterOption> options;
  final Function(FilterOption) onSelected;
  final String initialValue;

  const FilterCategoryBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
    required this.initialValue,
  });

  @override
  State<FilterCategoryBottomSheet> createState() =>
      _FilterCategoryBottomSheetState();
}

class _FilterCategoryBottomSheetState extends State<FilterCategoryBottomSheet> {
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

  @override
  Widget build(BuildContext context) {
    final individuOptions = widget.options
        .where((opt) => opt.id == '1' || opt.id == '2')
        .toList();
    final komunitasOptions = widget.options
        .where((opt) => opt.id == '3')
        .toList();
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
          const SizedBox(height: 16),
          MySeparator(),
          const SizedBox(height: 16),

          // Preferensi Section - Hanya menampilkan yang isPreferred = true
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Individu",
                style: TextStyleUI.SUBTITLE1.copyWith(
                  fontWeight: FontUI.WEIGHT_REGULAR,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: individuOptions.map((e) {
                    return _buildIndividuItem(context, e);
                  }).toList(),
                ),
              ),
              Column(
                children: komunitasOptions.map((e) {
                  return Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildKomunitasItem(context, e),
                  );
                }).toList(),
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
        ],
      ),
    );
  }

  Widget _buildIndividuItem(BuildContext context, FilterOption option) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  option.name,
                  style: TextStyleUI.BODY2.copyWith(
                    fontWeight: FontUI.WEIGHT_LIGHT,
                  ),
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

  Widget _buildKomunitasItem(BuildContext context, FilterOption option) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  option.name,
                  style: TextStyleUI.SUBTITLE1.copyWith(
                    fontWeight: FontUI.WEIGHT_REGULAR,
                  ),
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

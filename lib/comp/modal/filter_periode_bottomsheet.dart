import 'package:flutter/material.dart';
import 'package:test_case_ayo/comp/button/primary_button.dart';
import 'package:test_case_ayo/comp/separator.dart';
import 'package:test_case_ayo/model/leaderboard_model.dart';

import 'package:test_case_ayo/utils/constant.dart';

class FilterPeriodeBottomSheet extends StatefulWidget {
  final String title;
  final List<FilterOption> options;
  final Function(FilterOption) onSelected;
  final String initialValue;

  const FilterPeriodeBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
    required this.initialValue,
  });

  @override
  State<FilterPeriodeBottomSheet> createState() =>
      _FilterPeriodeBottomSheetState();
}

class _FilterPeriodeBottomSheetState extends State<FilterPeriodeBottomSheet> {
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

          // Preferensi Section - Hanya menampilkan yang isPreferred = true
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  return _buildPeriodeItem(context, option);
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

  Widget _buildPeriodeItem(BuildContext context, FilterOption option) {
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
          const Divider(height: 1, color: ColorUI.TEXT_INK10),
        ],
      ),
    );
  }
}

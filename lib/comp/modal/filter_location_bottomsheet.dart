import 'package:flutter/material.dart';
import 'package:test_case_ayo/comp/button/primary_button.dart';
import 'package:test_case_ayo/comp/separator.dart';
import 'package:test_case_ayo/model/leaderboard_model.dart';

import 'package:test_case_ayo/utils/constant.dart';

class FilterLocationBottomSheet extends StatefulWidget {
  final String title;
  final List<FilterOption> options;
  final Function(FilterOption) onSelected;
  final String initialValue;

  const FilterLocationBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
    required this.initialValue,
  });

  @override
  State<FilterLocationBottomSheet> createState() =>
      _FilterLocationBottomSheetState();
}

class _FilterLocationBottomSheetState extends State<FilterLocationBottomSheet> {
  late String _selectedId;
  late String _selectedName;
  final TextEditingController _searchController = TextEditingController();
  List<FilterOption> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    // Set initial value berdasarkan initialValue yang diberikan
    final initialOption = widget.options.firstWhere(
      (opt) => opt.name == widget.initialValue,
      orElse: () => widget.options.first,
    );
    _selectedId = initialOption.id;
    _selectedName = initialOption.name;
    _filteredOptions = widget.options;

    _searchController.addListener(_filterOptions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOptions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options
            .where((option) => option.name.toLowerCase().contains(query))
            .toList();
      }
    });
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
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari nama kota',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          MySeparator(),
          const SizedBox(height: 16),

          // Preferensi Section - Hanya menampilkan yang isPreferred = true
          SingleChildScrollView(
            child: Wrap(
              spacing: 8.0, // Spasi horizontal antara item
              runSpacing: 8.0, // Spasi vertikal antara baris
              children: _filteredOptions.map((option) {
                final isSelected = _selectedId == option.id;

                return FilterChip(
                  label: Text(
                    option.name,
                    style: TextStyleUI.BODY2.copyWith(
                      color: isSelected ? ColorUI.PRIMARY : ColorUI.TEXT_INK80,
                      fontWeight: FontUI.WEIGHT_REGULAR,
                    ),
                  ),
                  showCheckmark: false,
                  selected: isSelected,
                  selectedColor: ColorUI.FILL_CHIP,
                  labelStyle: TextStyle(
                    color: isSelected ? ColorUI.PRIMARY : ColorUI.BLACK,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedId = option.id;
                      _selectedName = option.name;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Apply Button
          const SizedBox(height: 16),
          PrimaryButton(
            text: "Terapkan",
            onPressed: () {
              // Cari option yang sesuai dengan _radioSelected
              final selectedOption = widget.options.firstWhere(
                (opt) => opt.id == _selectedId,
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
}

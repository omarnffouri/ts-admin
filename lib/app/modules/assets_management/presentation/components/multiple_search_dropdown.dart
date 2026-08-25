import 'package:flutter/material.dart';
import 'package:ts_admin/app/core/widgets/multi_select_search_dropdown.dart';

import '../../domain/entities/teams_entity.dart';

class MultipleSearchDropdown extends StatelessWidget {
  const MultipleSearchDropdown({
    super.key,
    required this.items,
    this.onPickedChanged,
  });
  final List<TeamsEntity> items;
  final void Function(List<TeamsEntity>)? onPickedChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(top: 10),
      child: MultiSelectSearchDropdown<TeamsEntity>(
        items: items,
        labelOf: (e) => e.name ?? "",
        hintText: 'Select Teams',
        onPickedChanged: (picked) => onPickedChanged?.call(picked),
      ),
    );
  }
}

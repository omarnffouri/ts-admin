import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/core/widgets/profile_image.dart';

/// Searchable multi-select with an always-on inline list, picked chips and a
/// "Select all" action. Self-contained (no external dropdown package) — used to
/// replace `multiple_search_selection`.
class MultiSelectSearchDropdown<T> extends StatefulWidget {
  const MultiSelectSearchDropdown({
    super.key,
    required this.items,
    required this.labelOf,
    required this.onPickedChanged,
    this.initialPicked = const [],
    this.hintText = 'Search',
    this.pickedChipRadius = 10,
    this.showSelectAllButton = true,
    this.showSearch = true,
    this.showLeadingAvatar = true,
    this.sortItems = true,
    this.maxSelections,
  });

  final List<T> items;
  final String Function(T item) labelOf;
  final void Function(List<T> picked) onPickedChanged;
  final List<T> initialPicked;
  final String hintText;
  final double pickedChipRadius;
  final bool showSelectAllButton;
  final bool showSearch;
  final bool showLeadingAvatar;
  final bool sortItems;
  final int? maxSelections;

  @override
  State<MultiSelectSearchDropdown<T>> createState() =>
      _MultiSelectSearchDropdownState<T>();
}

class _MultiSelectSearchDropdownState<T>
    extends State<MultiSelectSearchDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  late List<T> _picked;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _picked = List<T>.from(widget.initialPicked);
  }

  @override
  void didUpdateWidget(covariant MultiSelectSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Adopt an externally-provided selection (e.g. async pre-fill) only when it
    // actually changed and differs from what's already picked — avoids clobbering
    // the user's own picks and prevents rebuild loops.
    if (!_sameSelection(oldWidget.initialPicked, widget.initialPicked) &&
        !_sameSelection(_picked, widget.initialPicked)) {
      _picked = List<T>.from(widget.initialPicked);
    }
  }

  bool _sameSelection(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (final e in a) {
      if (!b.contains(e)) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _allSelected =>
      widget.items.isNotEmpty && _picked.length >= widget.items.length;

  bool get _atMax =>
      widget.maxSelections != null && _picked.length >= widget.maxSelections!;

  List<T> get _available {
    final q = _query.trim().toLowerCase();
    final list = widget.items
        .where((e) => !_picked.contains(e))
        .where((e) => q.isEmpty || widget.labelOf(e).toLowerCase().contains(q))
        .toList();
    if (widget.sortItems) {
      list.sort((a, b) => widget
          .labelOf(a)
          .toLowerCase()
          .compareTo(widget.labelOf(b).toLowerCase()));
    }
    return list;
  }

  void _pick(T item) {
    if (_atMax) return;
    setState(() => _picked = [..._picked, item]);
    widget.onPickedChanged(_picked);
  }

  void _unpick(T item) {
    setState(() => _picked = _picked.where((e) => e != item).toList());
    widget.onPickedChanged(_picked);
  }

  void _selectAll() {
    setState(() => _picked = List<T>.from(widget.items));
    widget.onPickedChanged(_picked);
  }

  void _clearAll() {
    setState(() => _picked = <T>[]);
    widget.onPickedChanged(_picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    const accent = AppColorsLight.mainColor;
    final surface = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final available = _available;
    final hideList =
        widget.items.isNotEmpty && _query.isEmpty && available.isEmpty;
    // Stay inline (so the parent page owns the scroll) until the list grows past
    // a cap; only then bound it and let it scroll/recycle internally (~48px/row).
    const maxInlineHeight = 280.0;
    final listOverflows = available.length * 48 > maxInlineHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showSearch)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (text) => setState(() => _query = text),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hintText,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: accent),
                    ),
                  ),
                ),
              ),
              if (widget.showSelectAllButton) ...[
                const SizedBox(width: 4),
                _buildSelectAllButton(accent),
              ],
            ],
          ),
        if (_picked.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _picked
                  .map((e) => _buildPickedChip(e, accent, isDark))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 2),
            child: Text(
              widget.maxSelections != null
                  ? '${_picked.length}/${widget.maxSelections} selected'
                  : '${_picked.length} selected',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
        ],
        if (!hideList)
          Container(
            margin: const EdgeInsets.only(top: 10),
            constraints: listOverflows
                ? const BoxConstraints(maxHeight: maxInlineHeight)
                : null,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: surface,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: available.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 18, color: Colors.grey.shade500),
                        const SizedBox(width: 8),
                        Text(
                          _query.isEmpty ? 'No items' : 'No matches',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: !listOverflows,
                    physics: listOverflows
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: available.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: borderColor),
                    itemBuilder: (context, index) {
                      final item = available[index];
                      final label = widget.labelOf(item);
                      final disabled = _atMax;
                      return InkWell(
                        onTap: disabled ? null : () => _pick(item),
                        child: Opacity(
                          opacity: disabled ? 0.4 : 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                if (widget.showLeadingAvatar) ...[
                                  ProfileImage.network(
                                    url: "",
                                    width: 28,
                                    height: 28,
                                    showLetterOnError: true,
                                    letter: label.isNotEmpty
                                        ? label[0].capitalize
                                        : "",
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Expanded(
                                  child: Text(
                                    label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  disabled
                                      ? Icons.lock_outline
                                      : Icons.add_circle_outline,
                                  size: 20,
                                  color: disabled ? Colors.grey : accent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
      ],
    );
  }

  Widget _buildSelectAllButton(Color accent) {
    return TextButton.icon(
      onPressed:
          widget.items.isEmpty ? null : (_allSelected ? _clearAll : _selectAll),
      style: TextButton.styleFrom(foregroundColor: accent),
      icon: Icon(
        _allSelected ? Icons.remove_done : Icons.done_all,
        size: 18,
      ),
      label: Text(_allSelected ? 'Clear' : 'All'),
    );
  }

  Widget _buildPickedChip(T item, Color accent, bool isDark) {
    return InkWell(
      onTap: () => _unpick(item),
      borderRadius: BorderRadius.circular(widget.pickedChipRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          border: Border.all(color: accent.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(widget.pickedChipRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.labelOf(item),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? Colors.white : accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.close, size: 16, color: accent),
          ],
        ),
      ),
    );
  }
}

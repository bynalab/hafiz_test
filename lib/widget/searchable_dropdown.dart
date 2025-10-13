import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) getDisplayText;
  final String Function(T item)? getSubText;
  final String Function(T item) getItemId;
  final String hintText;
  final String searchHint;
  final ValueChanged<T?> onChanged;
  final Widget Function(T item, bool isSelected)? itemBuilder;

  const SearchableDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.getDisplayText,
    this.getSubText,
    required this.getItemId,
    required this.hintText,
    this.searchHint = 'Search...',
    required this.onChanged,
    this.itemBuilder,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
      if (_isDropdownOpen) {
        _filteredItems = List.from(widget.items);
        _searchController.clear();
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filteredItems = widget.items.where((item) {
        final displayText = widget.getDisplayText(item).toLowerCase();
        final subText = widget.getSubText?.call(item);
        return displayText.contains(value.toLowerCase()) ||
            (subText?.toLowerCase().contains(value.toLowerCase()) ?? false);
      }).toList();
    });
  }

  void _selectItem(T item) {
    widget.onChanged(item);
    setState(() {
      _isDropdownOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.selectedItem != null
                        ? widget.getDisplayText(widget.selectedItem as T)
                        : widget.hintText,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: widget.selectedItem != null
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Icon(
                  _isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
        if (_isDropdownOpen) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: widget.searchHint,
                      hintStyle: GoogleFonts.montserrat(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = widget.selectedItem != null &&
                          widget.getItemId(widget.selectedItem as T) ==
                              widget.getItemId(item);

                      return InkWell(
                        onTap: () => _selectItem(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                          ),
                          child: widget.itemBuilder?.call(item, isSelected) ??
                              DefaultDropdownItem<T>(
                                item: item,
                                isSelected: isSelected,
                                getDisplayText: widget.getDisplayText,
                                getSubText: widget.getSubText,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class DefaultDropdownItem<T> extends StatelessWidget {
  final T item;
  final bool isSelected;
  final String Function(T item) getDisplayText;
  final String Function(T item)? getSubText;

  const DefaultDropdownItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.getDisplayText,
    this.getSubText,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = getDisplayText(item);
    final subText = getSubText?.call(item);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayText,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (subText != null &&
                  subText.isNotEmpty &&
                  subText != displayText) ...[
                const SizedBox(height: 2),
                Text(
                  subText,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isSelected)
          Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
      ],
    );
  }
}

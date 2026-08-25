import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'tenor_service.dart';

typedef GifSelected = void Function(TenorGif gif);

class TenorGifPicker extends StatefulWidget {
  final TenorService service;
  final GifSelected onSelected;
  final VoidCallback? onTap;
  const TenorGifPicker(
      {super.key, required this.service, required this.onSelected, this.onTap});

  @override
  State<TenorGifPicker> createState() => _TenorGifPickerState();
}

class _TenorGifPickerState extends State<TenorGifPicker> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  List<TenorGif> _items = [];
  String? _next;
  String _query = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 300 &&
          !_loading &&
          _next != null) {
        _load(pos: _next);
      }
    });
  }

  Future<void> _load({String? pos, bool clear = false}) async {
    setState(() => _loading = true);
    try {
      final page = await widget.service.fetch(query: _query, pos: pos);
      setState(() {
        if (clear) {
          _items = page.items;
        } else {
          _items.addAll(page.items);
        }
        _next = page.next;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearch(String value) {
    _query = value.trim();
    _next = null;
    _load(clear: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: TextField(
            controller: _controller,
            onChanged: _onSearch,
            onSubmitted: _onSearch,
            onTap: widget.onTap,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText: 'Search Tenor',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            controller: _scroll,
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: _items.length + (_loading ? 6 : 0),
            itemBuilder: (_, i) {
              if (i >= _items.length) {
                return const DecoratedBox(
                    decoration: BoxDecoration(color: Color(0x11000000)));
              }
              final gif = _items[i];
              final thumb = gif.tinyGifUrl ?? gif.gifUrl ?? gif.mp4Url;
              return InkWell(
                onTap: () => widget.onSelected(gif),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: thumb == null
                      ? const ColoredBox(color: Colors.black12)
                      : CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

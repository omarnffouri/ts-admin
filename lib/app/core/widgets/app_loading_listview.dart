import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingListView extends StatelessWidget {
  const LoadingListView({super.key, this.count = 20});
  final int count;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) => ShimmerPlaceholder(index: index),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
      ),
    );
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  final int index;
  const ShimmerPlaceholder({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white30,
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(top: index == 0 ? 14 : 0, left: 14, right: 14),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

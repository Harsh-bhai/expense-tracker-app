import 'package:flutter/material.dart';

class AnalysisExpansionTile extends StatelessWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const AnalysisExpansionTile({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        initiallyExpanded: initiallyExpanded,
        children: [child],
      ),
    );
  }
}

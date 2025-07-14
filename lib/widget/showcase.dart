import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCase extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget child;
  final GlobalKey<State<StatefulWidget>> widgetKey;

  const ShowCase({
    super.key,
    this.title,
    this.description,
    required this.widgetKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: widgetKey,
      enableAutoScroll: true,
      targetPadding: const EdgeInsets.all(10),
      title: title,
      titleAlignment: Alignment.centerLeft,
      titlePadding: EdgeInsets.only(bottom: 20),
      description: description,
      child: child,
    );
  }
}

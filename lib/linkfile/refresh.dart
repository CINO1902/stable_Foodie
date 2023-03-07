import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {
  final Widget child;
  final Future Function() onRefresh;
  final ScrollController control;

  RefreshWidget({
    super.key,
    required this.onRefresh,
    required this.child,
    required this.control,
  });

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) =>
      Platform.isAndroid ? buildAndroidList() : buildIOSList(widget.control);

  Widget buildAndroidList() => RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: widget.onRefresh,
        child: widget.child,
      );

  Widget buildIOSList(control) => CustomScrollView(
        controller: control,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: widget.onRefresh,
          ),
          SliverToBoxAdapter(child: widget.child),
        ],
      );
}

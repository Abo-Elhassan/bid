import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/shared/side_menu.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PageLayout extends StatefulWidget {
  final Widget content;
  final Function onRefresh;
  final String? title;
  final bool isDashboard;
  PageLayout({
    required this.onRefresh,
    required this.content,
    required this.isDashboard,
    this.title,
  });

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? ""),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                widget.onRefresh();
              },
            ),
          ],
        ),
        drawer: Helpers.getCurrentUser().roleType == 1
            ? SideMenu(Helpers.getCurrentUser().username.toString())
            : null,
        body: Stack(
          children: [
            if (widget.isDashboard)
              Positioned(
                right: -10,
                top: 150,
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Image.asset(
                    Assets.kEarthLines,
                    height: 300,
                    opacity: const AlwaysStoppedAnimation(.5),
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            widget.content
          ],
        ));
  }
}

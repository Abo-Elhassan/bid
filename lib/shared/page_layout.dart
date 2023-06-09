import 'package:bid_app/app/core/values/app_assets.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:bid_app/shared/side_menu.dart';
import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class PageLayout extends StatefulWidget {
  final Widget content;
  final Function onRefresh;
  final String? title;
  final bool isDashboard;
  final ScrollController? scrollController;
  PageLayout({
    required this.content,
    required this.onRefresh,
    this.title,
    required this.isDashboard,
    this.scrollController,
  });

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.scrollController != null
            ? FloatingActionButton(
                onPressed: () {
                  widget.scrollController!.animateTo(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear,
                  );
                },
                child: Icon(Icons.arrow_upward))
            : SizedBox(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  size: MediaQuery.of(context).size.width * 0.06,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
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
        drawer: SideMenu(Helpers.getCurrentUser().username.toString()),
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
                    height: MediaQuery.of(context).size.height * 0.45,
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

import 'package:bid_app/app/data/utilities/helpers.dart';
import 'package:bid_app/app/data/utilities/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PageLayout extends StatefulWidget {
  final Widget content;
  final Function refreshFunction;
  PageLayout({
    required this.refreshFunction,
    required this.content,
  });

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                setState(() {
                  widget.refreshFunction();
                });
              },
            ),
          ],
        ),
        drawer: SideMenu(Helpers.getCurrentUser().username.toString()),
        body: Stack(
          children: [
            Center(
              child: RotatedBox(
                quarterTurns: -1,
                child: Image.asset(
                  "assets/images/earth icon.png",
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

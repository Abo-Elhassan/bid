import 'package:bid_app/app/core/utilities/helpers.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  final String username;
  SideMenu(this.username);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        padding: EdgeInsets.only(
          top: mediaQuery.size.height * 0.1,
          bottom: mediaQuery.size.height * 0.02,
          right: mediaQuery.size.height * 0.02,
          left: mediaQuery.size.height * 0.02,
        ),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(83, 83, 181, 1),
                Color.fromRGBO(47, 38, 117, 1),
                Color.fromRGBO(32, 23, 78, 1),
              ],
              stops: [
                0.2,
                0.6,
                0.9,
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  username,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Pilat Heavy',
                    fontSize: mediaQuery.size.width * 0.04,
                  ),
                )
              ],
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.06,
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.03,
            ),
            if (Helpers.getCurrentUser().roleType != 3)
              TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                onPressed: () {
                  Get.offNamed(Routes.HOME);
                  Scaffold.of(context).openEndDrawer();
                },
                child: Text(
                  "DASHBOARD",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Pilat Heavy',
                    fontSize: mediaQuery.size.width * 0.035,
                  ),
                ),
              ),
            const Divider(
              thickness: 2,
              color: Color.fromRGBO(184, 182, 235, 1),
            ),
            if (Helpers.getCurrentUser().roleType != 2)
              TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                onPressed: () {
                  Get.offNamed(Routes.WEATHER_FORECAST);
                  Scaffold.of(context).openEndDrawer();
                },
                child: Text(
                  "WEATHER FORECAST",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Pilat Heavy',
                    fontSize: mediaQuery.size.width * 0.035,
                  ),
                ),
              ),
            SizedBox(
              height: mediaQuery.size.height * 0.55,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  onPressed: () {
                    Get.offNamed(Routes.LOGIN);
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Text(
                    "LOG OUT",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pilat Heavy',
                      fontSize: mediaQuery.size.width * 0.035,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.offNamed(Routes.LOGIN);
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

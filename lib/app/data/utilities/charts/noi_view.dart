import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:bid_app/app/data/utilities/charts/noi.dart';
import 'package:bid_app/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class NatureOfInvlovementView extends StatelessWidget {
  final List<BidWidgetDetails> bidWidgetDetails;
  NatureOfInvlovementView(
    this.bidWidgetDetails,
  );

  late List<BidWidgetDetails> noiData =
      bidWidgetDetails.where((wid) => wid.biTypeUno == 7).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "NATURE OF INVOLVEMENT",
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontFamily: 'Pilat Heavy',
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 400,
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: noiData.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 300,
                          child: SingleChildScrollView(
                            child: NatureOfInvolvement(
                              noiData,
                            ),
                          ),
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              Get.toNamed(
                                Routes.NATURE_OF_INVOLVEMENT,
                                arguments: noiData,
                              );
                            },
                            icon: Icon(
                              Icons.arrow_forward,
                            )),
                      ],
                    )
                  : Center(
                      child: Text("No Data to Render"),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

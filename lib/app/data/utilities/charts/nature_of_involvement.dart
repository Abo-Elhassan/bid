import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NatureOfInvolvement extends StatelessWidget {
  final List<BidWidgetDetails> bidWidgetDetails;
  NatureOfInvolvement(
    this.bidWidgetDetails,
  );

  late List<BidWidgetDetails> NOIData =
      bidWidgetDetails.where((wid) => wid.biTypeUno == 7).toList();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeData = Theme.of(context);
    return Table(
      border: TableBorder(
          verticalInside: BorderSide(
              width: 1, color: Colors.black38, style: BorderStyle.solid),
          horizontalInside: BorderSide(
              width: 1, color: Colors.black38, style: BorderStyle.solid)),
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(mediaQuery.size.width * 0.15),
        1: FixedColumnWidth(mediaQuery.size.width * 0.15),
        2: FixedColumnWidth(mediaQuery.size.width * 0.15),
        3: const FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
            decoration: BoxDecoration(
              color: Color.fromRGBO(235, 235, 240, 1),
            ),
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.03,
                ),
                child: Text(
                  "Country",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pilat Light',
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.03,
                ),
                child: Text(
                  "Port",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pilat Light',
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.03,
                ),
                child: Text(
                  "Terminal",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pilat Light',
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.03,
                ),
                child: Text(
                  "Nature of Involvement",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pilat Light',
                    fontSize: 11,
                  ),
                ),
              ),
            ]),
        TableRow(children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: mediaQuery.size.height * 0.03,
            ),
            child: Text(
              NOIData[0].countryCode.toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(110, 110, 114, 1),
                fontFamily: 'Pilat Light',
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: mediaQuery.size.height * 0.03,
            ),
            child: Text(
              NOIData[0].portCode.toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(110, 110, 114, 1),
                fontFamily: 'Pilat Light',
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: mediaQuery.size.height * 0.03,
            ),
            child: Text(
              NOIData[0].terminalCode.toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(110, 110, 114, 1),
                fontFamily: 'Pilat Light',
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: mediaQuery.size.height * 0.03,
            ),
            child: Text(
              NOIData[0].natureOfInvolvement.toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(110, 110, 114, 1),
                fontFamily: 'Pilat Light',
                fontSize: 12,
              ),
            ),
          ),
        ]),
      ],
    );
  }
}

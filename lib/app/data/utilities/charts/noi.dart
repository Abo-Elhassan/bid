import 'package:bid_app/app/data/models/responses/widget_data_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NatureOfInvolvement extends StatelessWidget {
  final List<BidWidgetDetails> noiData;
  NatureOfInvolvement(
    this.noiData,
  );
  Container buildHeader(MediaQueryData mediaQuery, String title) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: mediaQuery.size.height * 0.03,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Pilat Light',
          fontSize: 11,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeData = Theme.of(context);
    return Table(
      border: TableBorder(
          verticalInside: BorderSide(
              width: 1, color: Colors.black38, style: BorderStyle.solid),
          horizontalInside: BorderSide(
              width: 1, color: Colors.black38, style: BorderStyle.solid),
          bottom: BorderSide(
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
              buildHeader(mediaQuery, "Country"),
              buildHeader(mediaQuery, "Port"),
              buildHeader(mediaQuery, "Terminal"),
              buildHeader(mediaQuery, "Nature of Involvement"),
            ]),
        ...noiData.map((item) {
          final index = noiData.indexOf(item);
          return TableRow(children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: mediaQuery.size.height * 0.03,
              ),
              child: Text(
                noiData[index].countryCode.toString().toUpperCase(),
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
                noiData[index].portCode.toString().toUpperCase(),
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
                noiData[index].terminalCode.toString().toUpperCase(),
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
                noiData[index].natureOfInvolvement.toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromRGBO(110, 110, 114, 1),
                  fontFamily: 'Pilat Light',
                  fontSize: 12,
                ),
              ),
            ),
          ]);
        }).toList()
      ],
    );
  }
}

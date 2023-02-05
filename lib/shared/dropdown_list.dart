import 'package:bid_app/app/data/models/responses/filter_data_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DropDownList extends StatelessWidget {
  final List<Port> portList;
  final Port showedPort;
  final Function updateData;

  const DropDownList(
      {required this.portList,
      required this.showedPort,
      required this.updateData});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        dropdownColor: Colors.white,
        value: showedPort.portName,
        icon: Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: Colors.black,
        ),
        items: portList.map<DropdownMenuItem<String>>((wid) {
          return DropdownMenuItem(
            value: wid.portName,
            child: Text(
              wid.portName != null ? wid.portName! : "N/A",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Pilat Heavy',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          updateData(false, portName: newValue);
        });
  }
}

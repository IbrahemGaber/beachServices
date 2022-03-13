

import 'package:beaches_shop/widgets/add_to_card.dart';
import 'package:beaches_shop/widgets/save_for_later.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BootSheet extends StatefulWidget {
  final DocumentSnapshot snapshot;
  BootSheet(this.snapshot);
  @override
  _BootSheetState createState() => _BootSheetState();
}

class _BootSheetState extends State<BootSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
              flex: 1,
              child: AddToCard(widget.snapshot)),
          Flexible(
              flex:1,
              child: SaveForLater(widget.snapshot)),
        ],
      ),
    );
  }
}

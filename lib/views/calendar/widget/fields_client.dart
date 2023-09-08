import 'package:flutter/material.dart';

class FieldsClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: const Color.fromARGB(255, 0, 113, 199)),
      child: const DefaultTextStyle(
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}

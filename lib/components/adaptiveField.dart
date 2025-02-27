import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Adaptivefield extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final TextEditingController controller;
  final TextInputType keyboardType;

  Adaptivefield({
    super.key,
    required this.label,
    required this.onPressed,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: CupertinoTextField(
              controller: controller,
              onSubmitted: (_) => onPressed(),
              placeholder: label,
              keyboardType: keyboardType,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : TextField(
            controller: controller,
            onSubmitted: (_) => onPressed(),
            decoration: InputDecoration(labelText: label),
            keyboardType: keyboardType,
          );
  }
}

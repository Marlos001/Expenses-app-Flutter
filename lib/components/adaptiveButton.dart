import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class adaptiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  adaptiveButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(label),
            onPressed: onPressed,
            color: Colors.purple,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
          )
        : ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.purple),
                textStyle: WidgetStateProperty.all(const TextStyle(
                  color: Colors.white,
                ))),
            child: Text(label),
            onPressed: onPressed,
          );
  }
}

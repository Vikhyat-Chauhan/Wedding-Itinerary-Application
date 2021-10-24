import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 34,
        width: 34,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}

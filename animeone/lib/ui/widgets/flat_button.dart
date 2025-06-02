import 'package:flutter/material.dart';

/// A replacement for the deprecated `FlatButton`
class AnimeFlatButton extends StatelessWidget {
  const AnimeFlatButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}

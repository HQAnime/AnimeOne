import 'package:flutter/material.dart';

/// A replacement for the deprecated `FlatButton`
class AnimeFlatButton extends StatelessWidget {
  const AnimeFlatButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: child,
      ),
      onTap: onPressed,
    );
  }
}

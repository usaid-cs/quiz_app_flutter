import 'package:flutter/material.dart';

class btn extends StatelessWidget {
  const btn({
    super.key,
    required this.onClick,
    required this.btnIcon,
    required this.btnText,
  });

  final VoidCallback onClick;
  final IconData btnIcon;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onClick,
      icon: Icon(btnIcon),
      label: Text(btnText),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    );
  }
}

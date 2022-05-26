import 'package:flutter/material.dart';

const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ";
const colors = [
  Colors.orange,
  Colors.red,
  Colors.purple,
  Colors.blue,
  Colors.green,
];

class UserNameAvatar extends StatelessWidget {
  const UserNameAvatar({
    Key? key,
    required this.name,
    this.radius = 32,
  }) : super(key: key);

  final String name;
  final double radius;

  Color getColor(String? s) {
    if (s == null || s.trim().isEmpty) return colors.first;
    final letter = s.trim().toUpperCase()[0];
    final index = alphabet.indexOf(letter);
    return colors[index % colors.length];
  }

  String toInitials(String? name) {
    // if empty return empty
    if (name == null || name.isEmpty) return '';
    // if no space return first letter
    if (!name.contains(' ')) return name[0].toUpperCase();
    // split by space and return first letter and first letter of last split
    final split = name.split(' ');
    final initials = split[0][0] + split[split.length - 1][0];
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = toInitials(name);
    final color = getColor(name);
    return CircleAvatar(
      backgroundColor: color.withAlpha(32),
      radius: radius,
      child: Text(
        initials,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: radius / 1.2,
          color: color,
        ),
      ),
    );
  }
}

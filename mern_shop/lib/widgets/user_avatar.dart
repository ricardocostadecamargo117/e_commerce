import 'dart:io';
import 'package:flutter/material.dart';
import '../theme.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String? avatarPath; // local file path
  final String? avatarUrl;  // network url
  final double radius;

  const UserAvatar({
    super.key,
    required this.name,
    this.avatarPath,
    this.avatarUrl,
    this.radius = 24,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (avatarPath != null && avatarPath!.isNotEmpty) {
      imageProvider = FileImage(File(avatarPath!));
    } else if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      imageProvider = NetworkImage(avatarUrl!);
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: kGold.withOpacity(0.15),
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [kGoldDark, kGold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: TextStyle(
                    color: kBg,
                    fontSize: radius * 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

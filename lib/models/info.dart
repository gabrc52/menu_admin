/// Directamente de Menú Chapingo

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'date_truncation.dart';

extension on DateTime {
  String toCustomString() {
    final date = truncate();
    return '${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }
}

extension on String {
  DateTime? toDateTime() {
    if (length == 1) {
      return null;
    }
    assert(length == 8);
    int year = int.parse(substring(0, 4));
    int month = int.parse(substring(4, 6));
    int day = int.parse(substring(6, 8));
    return DateTime(year, month, day);
  }
}

class Info {
  const Info({
    this.title,
    this.subtitle,
    this.url,
    this.icon = Icons.info,
    this.date,
    this.isGlobal = false,
  });

  factory Info.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Info();
    }
    return Info(
      title: json['title'],
      subtitle: json['subtitle'],
      url: json['url'],
      icon: (json['icon'] != null)
          ? IconData(
              json['icon'],
              fontFamily: json['icon_font'] ?? 'MaterialIcons',
            )
          : Icons.info,
      date: (json['date'] is String)
          ? (json['date'] as String).toDateTime()
          : json['date'],
      isGlobal: json['date'] == '*',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'url': url,
      'icon': icon.codePoint,
      'icon_font': icon.fontFamily,
      'date': isGlobal ? '*' : date?.toCustomString(),
    };
  }

  final String? title;
  final String? subtitle;
  final String? url;
  final IconData icon;
  final DateTime? date;
  final bool isGlobal;

  ListTile toListTile({
    required VoidCallback onEditPressed,
    required VoidCallback onDeletePressed,
  }) {
    final onTap = url != null
        ? () async =>
            launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)
        : null;

    return ListTile(
      title: Text('[${isGlobal ? '*' : date.toString().split(' ')[0]}] $title'),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
      leading: Icon(icon),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (url != null)
            IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.launch),
            ),
          IconButton(
            onPressed: onEditPressed,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: onDeletePressed,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

/// Directamente de Menú Chapingo

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info {
  const Info({this.title, this.subtitle, this.url, this.icon = Icons.info});

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
    );
  }

  final String? title;
  final String? subtitle;
  final String? url;

  final IconData icon;

  ListTile toListTile() {
    return ListTile(
      title: Text(title!),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: url != null
          ? () async =>
              launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication)
          : null,
      leading: Icon(icon),
      trailing: url != null ? const Icon(Icons.launch) : null,
    );
  }

  bool get isNotNull => title != null || subtitle != null || url != null;
}

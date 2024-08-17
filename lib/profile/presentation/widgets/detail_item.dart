import 'package:flutter/material.dart';
import 'package:social_media_narrator/theme/app_color.dart';

class DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool multiline;

  const DetailItem({
    super.key,
    required this.label,
    required this.value,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: AppColor.profile,
            ),
          ),
          const SizedBox(height: 4.0),
          if (multiline)
            Text(
              value,
              style: const TextStyle(fontSize: 14.0),
            )
          else
            Text(
              value,
              style: const TextStyle(fontSize: 14.0, color: AppColor.grey),
            ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}

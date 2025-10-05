import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotosListCell extends StatelessWidget {
  final String titleString, imageUrl, subtitleString;
  final VoidCallback onTapEvent;

  const PhotosListCell({super.key, required this.titleString, required this.imageUrl, required this.subtitleString, required this.onTapEvent});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: onTapEvent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            ListTile(
              title: Text(titleString, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(subtitleString),
            ),
          ],
        ),
      ),
    );
  }

}
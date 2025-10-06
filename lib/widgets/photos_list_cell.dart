import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotosListCell extends StatefulWidget {
  final String titleString, imageUrl, subtitleString;
  final bool? isFavorite;
  final VoidCallback onTapEvent;
  final VoidCallback? onPressedDeleteButton;
  final void Function(bool pressed) onPhotosListCellPressedFavorite;

  const PhotosListCell({super.key, required this.titleString, required this.imageUrl, required this.subtitleString, required this.onTapEvent, required this.isFavorite, required this.onPhotosListCellPressedFavorite, this.onPressedDeleteButton});

  @override
  State<StatefulWidget> createState() => _PhotosListCell();
}
class _PhotosListCell extends State<PhotosListCell>{
  bool? _isFavorite = false;

  @override
  void initState() {
    _isFavorite = widget.isFavorite;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: widget.onTapEvent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: widget.imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            ListTile(
              title: Text(widget.titleString, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(widget.subtitleString),
              trailing:
              // only show favorite icon when this flag is not null
              (_isFavorite != null)?
                IconButton(
                  isSelected: _isFavorite,
                  icon: const Icon(Icons.favorite_outline),
                  selectedIcon: const Icon(Icons.favorite),
                  onPressed: () {
                    if (_isFavorite != null) {
                      if (mounted) {
                        setState(() {
                          _isFavorite = !_isFavorite!;
                        });
                      }
                      widget.onPhotosListCellPressedFavorite(_isFavorite!);
                    }
                },
                ) : null,
            ),
            (widget.onPressedDeleteButton != null)?
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onPressedDeleteButton,
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.all(2.0), child: Icon(Icons.bookmark_remove_outlined)),
                      Text('Remove', style: TextStyle(decoration: TextDecoration.underline)),
                    ],
                  )
                ),
              ) : const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

}
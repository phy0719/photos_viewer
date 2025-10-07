import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photos_viewer/appModel/photos_model.dart';

class PhotosListCell extends StatefulWidget {
  final String id, titleString, imageUrl, subtitleString;
  final VoidCallback onTapEvent;
  final VoidCallback? onPressedDeleteButton;
  final void Function(bool pressed)? onPhotosListCellPressedFavorite;

  const PhotosListCell({super.key, required this.titleString, required this.imageUrl, required this.subtitleString, required this.onTapEvent, required this.onPhotosListCellPressedFavorite, this.onPressedDeleteButton, required this.id});

  @override
  State<StatefulWidget> createState() => _PhotosListCell();
}
class _PhotosListCell extends State<PhotosListCell>{
  bool _isFavorite = false;

  updateIsFavoriteUI() {
    if (mounted) {
      setState(() {
        _isFavorite = PhotosModel.shared.favoriteIds.contains(widget.id);
      });
    }
  }

  @override
  void initState() {
    _isFavorite = PhotosModel.shared.favoriteIds.contains(widget.id);
    PhotosModel.shared.addListener(updateIsFavoriteUI);
    super.initState();
  }

  @override
  void dispose() {
    PhotosModel.shared.removeListener(updateIsFavoriteUI);
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
              (widget.onPhotosListCellPressedFavorite != null)?
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
                      if (widget.onPhotosListCellPressedFavorite != null) widget.onPhotosListCellPressedFavorite!(_isFavorite!);
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
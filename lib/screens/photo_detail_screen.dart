import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoDetailScreen extends StatefulWidget{
  final String screenTitle, imageUrl, location, description, createdBy, createdTimeString, takenAtString;
  final bool isFavorite;
  final void Function(bool pressed) onDetailPressedFavorite;

  const PhotoDetailScreen({super.key, required this.screenTitle, required this.imageUrl, required this.location, required this.description, required this.createdBy, required this.createdTimeString, required this.takenAtString, required this.isFavorite, required this.onDetailPressedFavorite});

  @override
  State<StatefulWidget> createState() => _PhotoDetailScreen();

}

class _PhotoDetailScreen extends State<PhotoDetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    _isFavorite = widget.isFavorite;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  Positioned(
                    left: 0.0,
                    top: 2.0,
                    child: IconButton(
                      iconSize: 35.0,
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        color: Colors.grey.shade400,
                      ),
                      tooltip: 'Back to Previous Page',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              ListTile(
                title: const Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(widget.location),
                trailing: IconButton(
                  isSelected: _isFavorite,
                  icon: const Icon(Icons.favorite_outline),
                  selectedIcon: const Icon(Icons.favorite),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                      widget.onDetailPressedFavorite(_isFavorite);
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(widget.description),
              ),
              ListTile(
                title: const Text('Created By:', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(widget.createdBy),
              ),
              ListTile(
                title: const Text('Created At:', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(widget.createdTimeString),
              ),
              ListTile(
                title: const Text('Taken At:', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(widget.takenAtString),
              ),
            ],
          ),
        ),
      )
    );

  }

}